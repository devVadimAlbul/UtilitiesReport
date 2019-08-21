import UIKit

extension SingUpViewController {
  
  enum InputItemType: String {
    case email
    case password
    case confirmPassword
    case firstName
    case lastName
    case phoneNumber
    case city
    case street
    case house
    case apartment
  }
  
  struct Props {
    enum ItemState {
      case valid
      case invalid(message: String)
    }
    
    enum PropsState {
      case edit
      case loading
      case falied(error: String)
      case success
    }
    
    struct Item {
      var name: String
      var value: String?
      var placeholder: String
      var change: CommandWith<String?>
      var state: ItemState
      
      static var initial: Item = Item(name: "", value: nil, placeholder: "", change: .nop, state: .valid)
    }
    
    var email: Item
    var password: Item
    var confirmPassword: Item
    var firstName: Item
    var lastName: Item
    var phoneNumber: Item
    
    var city: Item
    var street: Item
    var house: Item
    var apartment: Item
    var pageTitle: String
    var registerButtonTitle: String
    var state: PropsState
    var actionRegister: Command
    
    static var initial: Props = Props(
      email: .initial,
      password: .initial,
      confirmPassword: .initial,
      firstName: .initial,
      lastName: .initial,
      phoneNumber: .initial,
      city: .initial,
      street: .initial,
      house: .initial,
      apartment: .initial,
      pageTitle: "",
      registerButtonTitle: "",
      state: .edit,
      actionRegister: .nop
    )
  }
}
