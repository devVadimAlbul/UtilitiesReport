import Foundation

protocol LoginViewRouter {
  
}

class LoginViewRouterImpl: LoginViewRouter {
  
  private weak var viewController: LoginViewController?
  
  init(viewController: LoginViewController) {
    self.viewController = viewController
  }
}
