import Foundation

protocol LoginViewPresenter: PresenterProtocol {
  var router: LoginViewRouter { get set }
}

class LoginViewPresenterImpl: LoginViewPresenter {
  typealias Props = LoginViewController.Props
  
  enum PresenterState {
    case initial
    case valid
  }
  
  private weak var view: LoginView?
  private var model: SignInModel
  private var itemsPropsValiad: [PartialKeyPath<SignInModel>: PropsItemState] = [:]
  private var useCase: SignInUseCase
  var router: LoginViewRouter
  
  init(view: LoginView, router: LoginViewRouter, useCase: SignInUseCase) {
    self.view = view
    self.router = router
    self.useCase = useCase
    self.model = SignInModel()
  }
  
  func viewDidLoad() {
    presentProps()
  }
  
  private func presentProps(state: PresenterState = .initial, propsState: PropsState = .edit) {
    view?.props = generateProps(state: state, propsState: propsState)
  }
  
  // MARK: generate methods
  private func generateProps(state: PresenterState = .initial, propsState: PropsState = .edit) -> Props {
    
    func generateItem(with key: PartialKeyPath<SignInModel>, name: String,
                      action: @escaping (String?) -> Void) -> Props.Item {
      let placeholder = name
      let value = model[keyPath: key] as? String
      let command = CommandWith<String?>(action: { [weak self] changeValue in
        self?.itemsPropsValiad[key] = .valid
        action(changeValue)
      })
      let stateItem: PropsItemState = state == .initial ? .valid : (itemsPropsValiad[key] ?? .valid)
      return Props.Item(name: nil, value: value, placeholder: placeholder, change: command, state: stateItem)
    }

    return Props(email: generateItem(with: \SignInModel.email, name: "Email",
                                     action: {self.model.email = $0 ?? ""}),
                 password: generateItem(with: \SignInModel.password, name: "Password",
                                        action: {self.model.password = $0}),
                 pageTitle: "Sign IN",
                 loginButtonTitle: "Login",
                 state: propsState,
                 actionLogin: Command(action: loginModel))
  }
  
  private func loginModel() {
    guard let state = view?.props.state else { return }
    switch state {
    case .loading: return
    default:
      self.presentProps(state: .initial, propsState: .loading)
      if checkAllData() {
        sendLogin()
      } else {
        presentProps(state: .valid,
                     propsState: .falied(error: URError.incorrectSingUpData.localizedDescription))
      }
    }
  }
  
  private func checkAllData() -> Bool {
    if !model.email.removeWhiteSpace().isEmpty && model.email.isEmailValid {
      itemsPropsValiad[\SignInModel.email] = .valid
    } else {
      itemsPropsValiad[\SignInModel.email] = .invalid(message: "Incorrect email")
    }
    
    if let password = model.password, !password.removeWhiteSpace().isEmpty {
      itemsPropsValiad[\SignInModel.password] = .valid
    } else {
      itemsPropsValiad[\SignInModel.password] = .invalid(message: "Incorrect password")
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
  
  private func sendLogin() {
    self.useCase.login(user: model) { [weak self] (result) in
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
