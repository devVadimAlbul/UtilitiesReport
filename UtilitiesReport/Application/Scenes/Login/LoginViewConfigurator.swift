import Foundation

protocol LoginViewConfigurator {
  func configure(_ viewController: LoginViewController)
}

class LoginViewConfiguratorImpl: LoginViewConfigurator {
  
  func configure(_ viewController: LoginViewController) {
    let router = LoginViewRouterImpl(viewController: viewController)
    let useCase = SignInUseCaseImpl(gateway: AuthGatewayImpl(api: FirebaseAuthGatewayImpl(),
                                                             storage: UserProfileLocalStorageGatewayImpl()))
    let presenter = LoginViewPresenterImpl(view: viewController, router: router, useCase: useCase)
    
    viewController.presenter = presenter
  }
}
