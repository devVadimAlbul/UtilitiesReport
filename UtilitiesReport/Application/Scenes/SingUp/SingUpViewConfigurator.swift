import Foundation

protocol SingUpViewConfigurator {
  func configure(_ viewController: SingUpViewController)
}

class SingUpViewConfiguratorImpl: SingUpViewConfigurator {
  
  func configure(_ viewController: SingUpViewController) {
    let router = SingUpViewRouterImpl(viewController: viewController)
    
    let useCase = SingUpUseCaseImpl(gateway: AuthGatewayImpl(api: FirebaseAuthGatewayImpl(),
                                                             storage: UserProfileLocalStorageGatewayImpl()))
    
    let presenter = SingUpViewPresenterImpl(view: viewController, router: router, useCase: useCase)
    
    viewController.presenter = presenter
  }
}
