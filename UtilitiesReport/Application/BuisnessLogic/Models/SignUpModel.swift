import Foundation

struct SignUpModel {
  var email: String = ""
  var password: String?
  var confirmPassword: String?
  
  var firstName: String = ""
  var lastName: String = ""
  var phoneNumber: String = ""
  var city: String = ""
  var street: String = ""
  var house: String = ""
  var apartment: String?
  
  
  func getAllKeys() -> [PartialKeyPath<SignUpModel>] {
    return [
      \SignUpModel.email,
      \SignUpModel.password,
      \SignUpModel.confirmPassword,
      \SignUpModel.firstName,
      \SignUpModel.lastName,
      \SignUpModel.phoneNumber,
      \SignUpModel.city,
      \SignUpModel.street,
      \SignUpModel.house
    ]
  }
  
  var namesPaths: [PartialKeyPath<SignUpModel>: String] {
    return [
             \SignUpModel.email: "email",
             \SignUpModel.password: "psssword",
             \SignUpModel.confirmPassword: "confirm password",
             \SignUpModel.firstName: "first name",
             \SignUpModel.lastName: "last name",
             \SignUpModel.phoneNumber: "phone number",
             \SignUpModel.city: "city",
             \SignUpModel.street: "street",
             \SignUpModel.house: "house"
    ]
  }
  
  func jsonData() -> [String: Any] {
    var data: [String: Any] = [
      "firstName": firstName,
      "lastName": lastName,
      "phoneNumber": phoneNumber,
      "email": email,
      "city": city,
      "street": street,
      "house": house
    ]
    
    if let apt = apartment {
      data["apartment"] = apt
    }
    return data
  }
}
