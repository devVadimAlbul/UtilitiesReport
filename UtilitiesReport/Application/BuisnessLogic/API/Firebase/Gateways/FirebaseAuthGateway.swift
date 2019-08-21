import Foundation
import Firebase

class FirebaseAuthGatewayImpl: ApiAuthGateway {
  
  private var database: Firestore
  private var authApi: Auth
  
  init(database: Firestore = .firestore(), authApi: Auth = .auth()) {
    self.database = database
    self.authApi = authApi
  }
  
  func register(userModel: SingUpModel, complationHandler: @escaping RegisterComplationHandler) {
    guard let password = userModel.password else {
      complationHandler(.failure(URError.userNotCreated))
      return
    }
    authApi.createUser(withEmail: userModel.email, password: password) { [weak self] (result, error) in
      guard let `self` = self else { return }
      guard let result = result else {
        complationHandler(.failure(error ?? URError.userNotCreated))
        return
      }
      self.saveUser(userData: result.user, model: userModel, complationHandler: complationHandler)
    }
  }
  
  private func saveUser(userData: User, model: SingUpModel,
                        complationHandler: @escaping RegisterComplationHandler) {
    let collection = self.database.collection("Users")
    collection.document(userData.uid).setData(model.jsonData()) { error in
      if let error = error {
        complationHandler(.failure(error))
      }
      let userProfile = UserProfile(identifier: userData.uid,
                                    firstName: model.firstName,
                                    lastName: model.lastName,
                                    email: model.email,
                                    phoneNumber: model.phoneNumber,
                                    city: model.city,
                                    street: model.street,
                                    house: model.house,
                                    apartment: model.apartment)
      complationHandler(.success(userProfile))
    }
  }
}
