import Foundation

protocol SignUpViewRouter {
  func goToMainPage()
}

class SignUpViewRouterImpl: SignUpViewRouter {
  private weak var viewController: SignUpViewController?
  
  init(viewController: SignUpViewController) {
    self.viewController = viewController
  }
  
  func goToMainPage() {
    DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
      AppDelegate.shared.presenter.router.goToMainViewController()
    }
  }
}
