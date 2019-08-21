import Foundation

protocol AuthGateway {
  typealias RegisterComplationHandler = (Result<UserProfile, Error>) -> Void
  func register(userModel: SingUpModel, complationHandler: @escaping RegisterComplationHandler)
}

class AuthGatewayImpl: AuthGateway {
  
  private let api: ApiAuthGateway
  private let storage: UserProfileLocalStorageGateway
  
  init(api: ApiAuthGateway, storage: UserProfileLocalStorageGateway) {
    self.api = api
    self.storage = storage
  }
  
  func register(userModel: SingUpModel, complationHandler: @escaping RegisterComplationHandler) {
    api.register(userModel: userModel) { [weak self] (result) in
      switch result {
      case .success(let profile):
        self?.storage.save(parameters: profile, completionHandler: complationHandler)
      case .failure(let error):
        complationHandler(.failure(error))
      }
    }
  }
}
