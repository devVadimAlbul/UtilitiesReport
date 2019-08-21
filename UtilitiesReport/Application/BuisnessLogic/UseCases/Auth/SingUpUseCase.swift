import Foundation


protocol SingUpUseCase {
  typealias SingUpCompletionHandler = (Result<UserProfile, Error>) -> Void

  func register(user: SingUpModel, completionHandler: @escaping SingUpCompletionHandler)
}

class SingUpUseCaseImpl: SingUpUseCase {
  
  private let gateway: AuthGateway
  
  init(gateway: AuthGateway) {
    self.gateway = gateway
  }
  
  func register(user: SingUpModel, completionHandler: @escaping SingUpCompletionHandler) {
    gateway.register(userModel: user, complationHandler: completionHandler)
  }
}
