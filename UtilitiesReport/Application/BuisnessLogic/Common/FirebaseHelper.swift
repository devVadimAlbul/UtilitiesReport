import Foundation
import FirebaseFirestore
import Firebase


class FirebaseHelper: NSObject {
  
  static let shared: FirebaseHelper = FirebaseHelper()
  
  private var database: Firestore!

  override init() {
    database = Firestore.firestore()
    super.init()
  }
  
  func read() {
    database.collection("Company").getDocuments() { (query, error) in
      if let error = error {
        print("Error getting documents: \(error)")
      } else {
        for document in query!.documents {
          print("\(document.documentID) => \(document.data())")
        }
      }
    }
  }
}
