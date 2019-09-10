import Foundation

protocol SignInUseCase {
  typealias LoginCompletionHandler = (Result<UserProfile, Error>) -> Void
  
  func login(user: SignInModel, completionHandler: @escaping LoginCompletionHandler)
}

class SignInUseCaseImpl: SignInUseCase {
  
  private let gateway: AuthGateway
  
  init(gateway: AuthGateway) {
    self.gateway = gateway
  }

  func login(user: SignInModel, completionHandler: @escaping LoginCompletionHandler) {
    gateway.login(userModel: user, complationHandler: completionHandler)
  }
}
