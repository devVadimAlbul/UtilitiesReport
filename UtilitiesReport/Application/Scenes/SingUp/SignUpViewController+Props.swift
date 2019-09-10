import UIKit

extension SignUpViewController: PropsProtocol {
  
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
    
    struct Item {
      var name: String
      var value: String?
      var placeholder: String
      var change: CommandWith<String?>
      var state: PropsItemState
      
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
  
  func render(props: Props) {
    self.lblPageTitle.text = props.pageTitle
    btnRegiter.setTitle(props.registerButtonTitle, for: .normal)
    updateContentTextView(in: ftEmail, with: props.email)
    updateContentTextView(in: ftPassword, with: props.password)
    updateContentTextView(in: ftConfirmPassword, with: props.confirmPassword)
    updateContentTextView(in: ftFirstName, with: props.firstName)
    updateContentTextView(in: ftLastName, with: props.lastName)
    updateContentTextView(in: ftPhoneNumber, with: props.phoneNumber)
    updateContentTextView(in: ftCity, with: props.city)
    updateContentTextView(in: ftStreet, with: props.street)
    updateContentTextView(in: ftHouse, with: props.house)
    updateContentTextView(in: ftApartment, with: props.apartment)
    
    updatePageState(props.state)
    view.setNeedsLayout()
  }
  
  private func updateContentTextView(in textView: FormTextItemView, with item: Props.Item) {
    textView.placeholder = item.placeholder
    textView.title = item.name
    updateItemState(item.state, in: textView)
    updateTextIfNeeded(in: textView, with: item, using: \.value)
  }
}
