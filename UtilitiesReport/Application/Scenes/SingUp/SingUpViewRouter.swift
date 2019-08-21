import Foundation

protocol SingUpViewRouter {
  func goToMainPage()
}

class SingUpViewRouterImpl: SingUpViewRouter {
  private weak var viewController: SingUpViewController?
  
  init(viewController: SingUpViewController) {
    self.viewController = viewController
  }
  
  func goToMainPage() {
    DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
      AppDelegate.shared.presenter.router.goToMainViewController()
    }
  }
}
