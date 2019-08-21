import Foundation
import Firebase

class FirebaseCompaniesGatewayImpl: ApiCompaniesGateway {
  
  private var database: Firestore
  
  init(database: Firestore = .firestore()) {
    self.database = database
  }
  
  func load(by identifier: String, completionHandler: @escaping LoadEntityCompletionHandler) {
    database.collection("Company").document(identifier).getDocument { (query, error) in
      if let error = error {
        completionHandler(.failure(error))
      } else {
        let item = Company(identifier: query!.documentID, data: query!.data() ?? [:])
        completionHandler(.success(item))
      }
    }
  }
  
  func fetch(completionHandler: @escaping FetchEntitiesCompletionHandler) {
    database.collection("Company").getDocuments { (query, error) in
      if let error = error {
        completionHandler(.failure(error))
      } else {
        let resultData = query?.documents.map({Company(identifier: $0.documentID, data: $0.data())}) ?? []
        completionHandler(.success(resultData))
      }
    }
  }
  
  func delete(entity: Company, completionHandler: @escaping DeleteEntityCompletionHandler) {
    completionHandler(.success(()))
  }
  
  func deleteAll(completionHandler: @escaping (Result<Void, Error>) -> Void) {
    completionHandler(.success(()))
  }
}
