import Foundation

struct SignInModel {
  var email: String = ""
  var password: String?
  
  func getAllKeys() -> [PartialKeyPath<SignInModel>] {
    return [
      \SignInModel.email,
      \SignInModel.password
    ]
  }
  
  var namesPaths: [PartialKeyPath<SignInModel>: String] {
    return [
      \SignInModel.email: "email",
      \SignInModel.password: "psssword"
    ]
  }
}
