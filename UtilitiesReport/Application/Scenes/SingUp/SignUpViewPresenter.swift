import Foundation

protocol SignUpViewPresenter: PresenterProtocol {
  var router: SignUpViewRouter { get set }
}

class SignUpViewPresenterImpl: SignUpViewPresenter {
  typealias Props = SignUpViewController.Props
  
  enum PresenterState {
    case initial
    case valid
  }

  var router: SignUpViewRouter
  private weak var view: SignUpView?
  private var model: SignUpModel = .init()
  private var useCase: SignUpUseCase
  fileprivate var itemsPropsValiad: [PartialKeyPath<SignUpModel>: PropsItemState] = [:]
  
  init(view: SignUpView, router: SignUpViewRouter, useCase: SignUpUseCase) {
    self.view = view
    self.router = router
    self.useCase = useCase
  }
  
  func viewDidLoad() {
    presentProps()
  }
  
  private func presentProps(state: PresenterState = .initial, propsState: PropsState = .edit) {
    view?.props = generateProps(state: state, propsState: propsState)
  }

  // MARK: generate methods
  private func generateProps(state: PresenterState = .initial, propsState: PropsState = .edit) -> Props {
    
    func generateItem(with key: PartialKeyPath<SignUpModel>, name: String,
                      action: @escaping (String?) -> Void) -> Props.Item {
      let placeholder = "Enter \(name.lowercased())"
      let value = model[keyPath: key] as? String
      let command = CommandWith<String?>(action: { [weak self, key] changeValue in
        self?.itemsPropsValiad[key] = .valid
        action(changeValue)
      })
      let stateItem: PropsItemState = state == .initial ? .valid : (itemsPropsValiad[key] ?? .valid)
      return Props.Item(name: "\(name):", value: value, placeholder: placeholder, change: command, state: stateItem)
    }
    
    return Props(
      email: generateItem(with: \SignUpModel.email, name: "Email",
                          action: { self.model.email = $0 ?? ""}),
      password: generateItem(with: \SignUpModel.password, name: "Password",
                             action: {self.model.password = $0}),
      confirmPassword: generateItem(with: \SignUpModel.confirmPassword, name: "Confirm password",
                                    action: {self.model.confirmPassword = $0}),
      firstName: generateItem(with: \SignUpModel.firstName, name: "First Name",
                              action: {self.model.firstName = $0 ?? ""}),
      lastName: generateItem(with: \SignUpModel.lastName, name: "Last Name",
                             action: {self.model.lastName = $0 ?? ""}),
      phoneNumber: generateItem(with: \SignUpModel.phoneNumber, name: "Phone number",
                                action: {self.model.phoneNumber = $0 ?? ""}),
      city: generateItem(with: \SignUpModel.city, name: "City",
                         action: {self.model.city = $0 ?? ""}),
      street: generateItem(with: \SignUpModel.street, name: "Street",
                           action: {self.model.street = $0 ?? ""}),
      house: generateItem(with: \SignUpModel.house, name: "House",
                          action: {self.model.house = $0 ?? ""}),
      apartment: generateItem(with: \SignUpModel.apartment, name: "Apartment",
                              action: {self.model.apartment = $0}),
      pageTitle: "Sing Up",
      registerButtonTitle: "Register",
      state: propsState,
      actionRegister: Command(action: registerModel)
    )
  }
  
  private func registerModel() {
      guard let state = view?.props.state else { return }
      switch state {
      case .loading: return
      default:
        presentProps(state: .initial, propsState: .loading)
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
    
    func checkValid(key: PartialKeyPath<SignUpModel>,
                    name: String, check: (String?) -> Bool) -> PropsItemState {
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
        if keyPath == \SignUpModel.email {
          return value.isEmailValid
        }
        if keyPath == \SignUpModel.phoneNumber {
          return value.isPhoneNumberValid
        }
        return true
      })
      self.itemsPropsValiad[keyPath] = state
    })
    
    if let password = model.password, let confirm = model.confirmPassword, password != confirm {
      let message = "This password does not match that entered in the password field."
      itemsPropsValiad[\SignUpModel.confirmPassword] = .invalid(message: message)
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
      DispatchQueue.main.async {
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

}
