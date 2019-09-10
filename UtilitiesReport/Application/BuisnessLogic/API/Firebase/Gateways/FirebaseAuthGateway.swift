import Foundation
import Firebase
import FirebaseFirestore

class FirebaseAuthGatewayImpl: ApiAuthGateway {
  
  private var database: Firestore
  private var authApi: Auth
  
  init(database: Firestore = .firestore(), authApi: Auth = .auth()) {
    self.database = database
    self.authApi = authApi
  }
  
  func register(userModel: SignUpModel, complationHandler: @escaping AuthComplationHandler) {
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
  
  func login(userModel: SignInModel, complationHandler: @escaping AuthComplationHandler) {
    guard let password = userModel.password else {
      complationHandler(.failure(URError.userNotAuth))
      return
    }
    
    authApi.signIn(withEmail: userModel.email, password: password) { [weak self] (result, error) in
      guard let `self` = self else { return }
      guard let result = result else {
        complationHandler(.failure(error ?? URError.userNotAuth))
        return
      }
      self.loadSavedUser(userData: result.user, complationHandler: complationHandler)
    }
  }
  
  func logout(complationHandler: @escaping LogoutComplationHandler) {
    do {
      _ = try authApi.signOut()
      complationHandler(.success(()))
    } catch {
      complationHandler(.failure(error))
    }
  }
  
  private func saveUser(userData: User, model: SignUpModel,
                        complationHandler: @escaping AuthComplationHandler) {
    let collection = self.database.collection("Users")
    collection.document(userData.uid).setData(model.jsonData()) { error in
      if let error = error {
        complationHandler(.failure(error))
        return
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
  
  private func loadSavedUser(userData: User, complationHandler: @escaping AuthComplationHandler) {
     let collection = self.database.collection("Users")
    collection.document(userData.uid).getDocument { [weak self] (data, error) in
      guard let dataContent = data?.data() else {
        _ = try? self?.authApi.signOut()
        complationHandler(.failure(error ?? URError.userNotAuth))
        return
      }
      let userProfile = UserProfile(identifier: userData.uid, data: dataContent)
      complationHandler(.success(userProfile))
    }
  }
}
