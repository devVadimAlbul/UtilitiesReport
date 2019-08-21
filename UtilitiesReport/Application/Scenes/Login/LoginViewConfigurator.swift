import Foundation

protocol LoginViewConfigurator {
  func configure(_ viewController: LoginViewController)
}

class LoginViewConfiguratorImpl: LoginViewConfigurator {
  
  func configure(_ viewController: LoginViewController) {
    let router = LoginViewRouterImpl(viewController: viewController)
    
    let presenter = LoginViewPresenterImpl(view: viewController, router: router)
    
    viewController.presenter = presenter
  }
}
