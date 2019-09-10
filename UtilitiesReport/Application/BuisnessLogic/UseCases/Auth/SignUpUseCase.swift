import Foundation


protocol SignUpUseCase {
  typealias SingUpCompletionHandler = (Result<UserProfile, Error>) -> Void

  func register(user: SignUpModel, completionHandler: @escaping SingUpCompletionHandler)
}

class SignUpUseCaseImpl: SignUpUseCase {
  
  private let gateway: AuthGateway
  
  init(gateway: AuthGateway) {
    self.gateway = gateway
  }
  
  func register(user: SignUpModel, completionHandler: @escaping SingUpCompletionHandler) {
    gateway.register(userModel: user, complationHandler: completionHandler)
  }
}
