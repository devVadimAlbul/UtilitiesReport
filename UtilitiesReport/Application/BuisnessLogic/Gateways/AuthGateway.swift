import Foundation

protocol AuthGateway {
  typealias AuthComplationHandler = (Result<UserProfile, Error>) -> Void
  typealias LogoutComplationHandler = (Result<Void, Error>) -> Void
  func register(userModel: SignUpModel, complationHandler: @escaping AuthComplationHandler)
  func login(userModel: SignInModel, complationHandler: @escaping AuthComplationHandler)
  func logout(complationHandler: @escaping LogoutComplationHandler)
}

class AuthGatewayImpl: AuthGateway {
  
  private let api: ApiAuthGateway
  private let storage: UserProfileLocalStorageGateway
  
  init(api: ApiAuthGateway, storage: UserProfileLocalStorageGateway) {
    self.api = api
    self.storage = storage
  }
  
  func register(userModel: SignUpModel, complationHandler: @escaping AuthComplationHandler) {
    api.register(userModel: userModel) { [weak self] (result) in
      switch result {
      case .success(let profile):
        self?.storage.save(parameters: profile, completionHandler: complationHandler)
      case .failure(let error):
        self?.storage.deleteAll(completionHandler: { _ in })
        complationHandler(.failure(error))
      }
    }
  }
  
  func login(userModel: SignInModel, complationHandler: @escaping AuthComplationHandler) {
    api.login(userModel: userModel) { [weak self] (result) in
      switch result {
      case .success(let profile):
        self?.storage.save(parameters: profile, completionHandler: complationHandler)
      case .failure(let error):
        self?.storage.deleteAll(completionHandler: { _ in })
        complationHandler(.failure(error))
      }
    }
  }
  
  func logout(complationHandler: @escaping LogoutComplationHandler) {
    api.logout(complationHandler: { result in
      switch result {
      case .success:
        self.storage.deleteAll(completionHandler: complationHandler)
      case .failure(let error):
        complationHandler(.failure(error))
      }
    })
  }
}
