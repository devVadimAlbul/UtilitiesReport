import Foundation

protocol LoginViewRouter {
  func goToMainPage()
}

class LoginViewRouterImpl: LoginViewRouter {
  
  private weak var viewController: LoginViewController?
  
  init(viewController: LoginViewController) {
    self.viewController = viewController
  }
  
  func goToMainPage() {
    DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
      AppDelegate.shared.presenter.router.goToMainViewController()
    }
  }
}
