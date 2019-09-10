import Foundation

extension LoginViewController: PropsProtocol {
  
  enum InputItemType: String {
    case email
    case password
  }
  
  struct Props {
    
    struct Item {
      var name: String?
      var value: String?
      var placeholder: String
      var change: CommandWith<String?>
      var state: PropsItemState
      
      static var initial: Item = Item(name: nil, value: nil, placeholder: "", change: .nop, state: .valid)
    }
    
    var email: Item
    var password: Item
    
    var pageTitle: String
    var loginButtonTitle: String
    var state: PropsState
    var actionLogin: Command
    
    static var initial: Props = Props(
      email: .initial,
      password: .initial,
      pageTitle: "",
      loginButtonTitle: "",
      state: .edit,
      actionLogin: .nop
    )
  }
  
  func render(props: Props) {
    self.lblPageTitle.text = props.pageTitle
    btnLogin.setTitle(props.loginButtonTitle, for: .normal)
    updateContentTextView(in: ftEmail, with: props.email)
    updateContentTextView(in: ftPassword, with: props.password)
    
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
