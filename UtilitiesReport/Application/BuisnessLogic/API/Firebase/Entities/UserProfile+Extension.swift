import Foundation

extension UserProfile {
  
  convenience init(identifier: String, data: [String: Any]) {
    self.init(identifier: identifier,
              firstName: (data["firstName"] as? String) ?? "",
              lastName: (data["lastName"] as? String) ?? "",
              email: (data["email"] as? String) ?? "",
              phoneNumber: (data["phoneNumber"] as? String) ?? "",
              city: (data["city"] as? String) ?? "",
              street: (data["street"] as? String) ?? "",
              house: (data["house"] as? String) ?? "",
              apartment: data["apartment"] as? String)
  }
}
