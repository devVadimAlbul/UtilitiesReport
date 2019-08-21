import Foundation

protocol SingUpViewPresenter: PresenterProtocol {
  var router: SingUpViewRouter { get set }
}

class SingUpViewPresenterImpl: SingUpViewPresenter {
  typealias Props = SingUpViewController.Props
  
  enum PresenterState {
    case initial
    case valid
  }

  var router: SingUpViewRouter
  private weak var view: SingUpView?
  private var model: SingUpModel = .init()
  private var useCase: SingUpUseCase
  fileprivate var itemsPropsValiad: [PartialKeyPath<SingUpModel>: Props.ItemState] = [:]
  
  init(view: SingUpView, router: SingUpViewRouter, useCase: SingUpUseCase) {
    self.view = view
    self.router = router
    self.useCase = useCase
  }
  
  func viewDidLoad() {
    presentProps()
  }
  
  private func presentProps(state: PresenterState = .initial, propsState: Props.PropsState = .edit) {
    view?.props = generateProps(state: state, propsState: propsState)
  }

  // MARK: generate methods
  private func generateProps(state: PresenterState = .initial, propsState: Props.PropsState = .edit) -> Props {
    
    func generateItem(with key: PartialKeyPath<SingUpModel>, name: String,
                      action: @escaping (String?) -> Void) -> Props.Item {
      let placeholder = "Enter \(name.lowercased())"
      let value = model[keyPath: key] as? String
      let command = CommandWith<String?>(action: { [weak self, key] changeValue in
        self?.itemsPropsValiad[key] = .valid
        action(changeValue)
      })
      let stateItem: Props.ItemState = state == .initial ? .valid : (itemsPropsValiad[key] ?? .valid)
      return Props.Item(name: "\(name):", value: value, placeholder: placeholder, change: command, state: stateItem)
    }
    
    return Props(
      email: generateItem(with: \SingUpModel.email, name: "Email",
                          action: { self.model.email = $0 ?? ""}),
      password: generateItem(with: \SingUpModel.password, name: "Password",
                             action: {self.model.password = $0}),
      confirmPassword: generateItem(with: \SingUpModel.confirmPassword, name: "Confirm password",
                                    action: {self.model.confirmPassword = $0}),
      firstName: generateItem(with: \SingUpModel.firstName, name: "First Name",
                              action: {self.model.firstName = $0 ?? ""}),
      lastName: generateItem(with: \SingUpModel.lastName, name: "Last Name",
                             action: {self.model.lastName = $0 ?? ""}),
      phoneNumber: generateItem(with: \SingUpModel.phoneNumber, name: "Phone number",
                                action: {self.model.phoneNumber = $0 ?? ""}),
      city: generateItem(with: \SingUpModel.city, name: "City",
                         action: {self.model.city = $0 ?? ""}),
      street: generateItem(with: \SingUpModel.street, name: "Street",
                           action: {self.model.street = $0 ?? ""}),
      house: generateItem(with: \SingUpModel.house, name: "House",
                          action: {self.model.house = $0 ?? ""}),
      apartment: generateItem(with: \SingUpModel.apartment, name: "Apartment",
                              action: {self.model.apartment = $0}),
      pageTitle: "Sing Up",
      registerButtonTitle: "Register",
      state: propsState,
      actionRegister: Command(action: registerModel)
    )
  }
  
  private func changeState(_ state: Props.PropsState) {
    view?.props.state = state
  }
  
  private func registerModel() {
      guard let state = view?.props.state else { return }
      switch state {
      case .loading: return
      default:
        changeState(.loading)
        if checkAllData() {
          sendToRegister()
        } else {
          presentProps(state: .valid,
                       propsState: .falied(error: URError.incorrectSingUpData.localizedDescription))
        }
      }
  }

  private func checkAllData() -> Bool {
    self.itemsPropsValiad.removeAll()
    
    func checkValid(key: PartialKeyPath<SingUpModel>,
                    name: String, check: (String?) -> Bool) -> Props.ItemState {
      let value = model[keyPath: key] as? String
      if check(value) {
        return .valid
      }
      return .invalid(message: "Incorrect \(name)")
    }
    
    model.getAllKeys().forEach({ keyPath in
      let state = checkValid(key: keyPath,
                             name: model.namesPaths[keyPath] ?? "",
                             check: { (value) -> Bool in
        guard let value = value, !value.removeWhiteSpace().isEmpty else { return false }
        if keyPath == \SingUpModel.email {
          return value.isEmailValid
        }
        if keyPath == \SingUpModel.phoneNumber {
          return value.isPhoneNumberValid
        }
        if keyPath == \SingUpModel.password {
          return value.count > 5
        }
        return true
      })
      self.itemsPropsValiad[keyPath] = state
    })
    
    if let password = model.password, let confirm = model.confirmPassword, password != confirm {
      let message = "This password does not match that entered in the password field."
      itemsPropsValiad[\SingUpModel.confirmPassword] = .invalid(message: message)
    }
    
    if itemsPropsValiad.values.contains(where: { (item) -> Bool in
      switch item {
      case .invalid(message: _): return true
      case .valid: return false
      }
    }) {
      return false
    }
    return true
  }
  
  private func sendToRegister() {
    useCase.register(user: model) { [weak self] (result) in
      guard let `self` = self else { return }
      switch result {
      case .success:
        self.presentProps(state: .valid, propsState: .success)
        self.router.goToMainPage()
      case .failure(let error):
        self.presentProps(state: .valid,
                          propsState: .falied(error: error.localizedDescription))
      }
    }
  }

}
