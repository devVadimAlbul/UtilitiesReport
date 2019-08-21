import Foundation

struct SingUpModel {
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
  
  
  func getAllKeys() -> [PartialKeyPath<SingUpModel>] {
    return [
      \SingUpModel.email,
      \SingUpModel.password,
      \SingUpModel.confirmPassword,
      \SingUpModel.firstName,
      \SingUpModel.lastName,
      \SingUpModel.phoneNumber,
      \SingUpModel.city,
      \SingUpModel.street,
      \SingUpModel.house
    ]
  }
  
  var namesPaths: [PartialKeyPath<SingUpModel>: String] {
    return [
             \SingUpModel.email: "email",
             \SingUpModel.password: "psssword",
             \SingUpModel.confirmPassword: "confirm password",
             \SingUpModel.firstName: "first name",
             \SingUpModel.lastName: "last name",
             \SingUpModel.phoneNumber: "phone number",
             \SingUpModel.city: "city",
             \SingUpModel.street: "street",
             \SingUpModel.house: "house"
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
