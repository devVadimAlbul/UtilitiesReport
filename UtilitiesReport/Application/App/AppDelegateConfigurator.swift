import Foundation
import Firebase

protocol AppDelegateConfigurator: class {
  func configure(delegate: AppDelegate)
}

class AppDelegateConfiguratorImpl: AppDelegateConfigurator {
  
  func configure(delegate: AppDelegate) {
    FirebaseApp.configure()
    let userProfileGateway = UserProfileGatewayImpl(api: FirebaseUserProfileGatewayImpl(),
                                                    storage: UserProfileLocalStorageGatewayImpl())
    let userUseCase = LoadUserProfileUseCaseImpl(gateway: userProfileGateway)
    let router = AppDelegateRouterImpl(delegate: delegate)
    let presenter = AppDelegatePresenterImpl(appDelegate: delegate, router: router,
                                             userUseCase: userUseCase)
    delegate.presenter = presenter
  }
}
