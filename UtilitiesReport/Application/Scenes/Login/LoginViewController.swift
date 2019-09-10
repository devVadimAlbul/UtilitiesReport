import UIKit

protocol LoginView: AnyObject {
  var configurator: LoginViewConfigurator! { get set }
  var props: LoginViewController.Props { get set }
}

class LoginViewController: BasicViewController, LoginView {
  
  // MARK: IBOutlet
  @IBOutlet weak var lblPageTitle: UILabel!
  @IBOutlet weak var btnClose: UIButton!
  @IBOutlet weak var ftEmail: FormTextItemView!
  @IBOutlet weak var ftPassword: FormTextItemView!
  @IBOutlet weak var btnLogin: ButtonRound!
  
  // MARK: property
  var configurator: LoginViewConfigurator!
  private var loginPresenter: LoginViewPresenter? {
    return presenter as? LoginViewPresenter
  }
  var props: Props = .initial {
    didSet {
      render(props: props)
    }
  }
  
  override func viewDidLoad() {
    configurator?.configure(self)
    super.viewDidLoad()
    setupUIContent()
  }
  
  // NARK: render ui content
  private func setupUIContent() {
    setTextViewParams(in: ftEmail, with: InputItemType.email.rawValue, keyboard: .emailAddress, nextView: ftPassword)
    setTextViewParams(in: ftPassword, with: InputItemType.password.rawValue)
  }
  
  private func setTextViewParams(in textView: FormTextItemView, with identifire: String,
                                 keyboard: UIKeyboardType = .default, nextView: FormTextItemView? = nil) {
    textView.identifier = identifire
    textView.keyboardType = keyboard
    textView.returnKeyType = nextView == nil ? .done : .next
    textView.nextFormItem = nextView
    textView.delegate = self
  }
  
  // MARK: IBAction
  @IBAction func clickedClose(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func clickedLogin(_ sender: Any) {
    props.actionLogin.perform()
  }
}

extension LoginViewController: FormTextItemViewDelegate {
  
  func didChangeFormText(view: FormTextItemView, at text: String?) {
    guard let inputItemType = InputItemType(rawValue: view.identifier) else { return }
    switch inputItemType {
    case .email:
      props.email.change.perform(with: text)
    case .password:
      props.password.change.perform(with: text)
    }
  }
}
