import Foundation

protocol SignUpViewConfigurator {
  func configure(_ viewController: SignUpViewController)
}

class SignUpViewConfiguratorImpl: SignUpViewConfigurator {
  
  func configure(_ viewController: SignUpViewController) {
    let router = SignUpViewRouterImpl(viewController: viewController)
    
    let useCase = SignUpUseCaseImpl(gateway: AuthGatewayImpl(api: FirebaseAuthGatewayImpl(),
                                                             storage: UserProfileLocalStorageGatewayImpl()))
    
    let presenter = SignUpViewPresenterImpl(view: viewController, router: router, useCase: useCase)
    
    viewController.presenter = presenter
  }
}
