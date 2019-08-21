import Foundation
import Firebase

protocol FirebaseUserProfileGateway: ApiUserProfileGateway {
  
}

class FirebaseUserProfileGatewayImpl: FirebaseUserProfileGateway {
  
  private var database: Firestore
  private var auth: Auth
  
  init(database: Firestore = .firestore(), auth: Auth = .auth()) {
    self.database = database
    self.auth = auth
  }
  
  func load(completionHandler: @escaping LoadUserProfileCompletionHandler) {
    guard let currentUser = auth.currentUser else {
      completionHandler(.failure(URError.userNotAuth))
      return
    }
    
    let collection = database.collection("Users")
    collection.document(currentUser.uid).getDocument { (result, error) in
      guard let result = result, let data = result.data() else {
        completionHandler(.failure(error ?? URError.userNotFound))
        return
      }
      let profile = UserProfile(identifier: result.documentID, data: data)
      completionHandler(.success(profile))
    }
  }
  
  func save(parameters: UserProfile, completionHandler: @escaping AddUserProfileCompletionHandler) {
    completionHandler(.success(parameters))
  }
  
  func delete(entity: UserProfile, completionHandler: @escaping DeleteUserProfileCompletionHandler) {
    completionHandler(.success(()))
  }
}
