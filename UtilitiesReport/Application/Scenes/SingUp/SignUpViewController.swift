import UIKit
import Hero

protocol SignUpView: AnyObject {
  var configurator: SignUpViewConfigurator! { get set }
  var props: SignUpViewController.Props { get set }
}

class SignUpViewController: BasicViewController, SignUpView {
  
  // MARK: IBOutlet
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var btnClose: UIButton!
  @IBOutlet weak var lblPageTitle: UILabel!
  @IBOutlet weak var ftEmail: FormTextItemView!
  @IBOutlet weak var ftPassword: FormTextItemView!
  @IBOutlet weak var ftConfirmPassword: FormTextItemView!
  
  @IBOutlet weak var ftFirstName: FormTextItemView!
  @IBOutlet weak var ftLastName: FormTextItemView!
  @IBOutlet weak var ftPhoneNumber: FormTextItemView!
  @IBOutlet weak var ftCity: FormTextItemView!
  @IBOutlet weak var ftStreet: FormTextItemView!
  @IBOutlet weak var ftHouse: FormTextItemView!
  @IBOutlet weak var ftApartment: FormTextItemView!
  @IBOutlet weak var btnRegiter: ButtonRound!
  
  // MARK: property
  var configurator: SignUpViewConfigurator!
  private var singUpPresenter: SignUpViewPresenter? {
    return presenter as? SignUpViewPresenter
  }
  var props: SignUpViewController.Props = .initial {
    didSet {
      render(props: props)
    }
  }
  
  // MARK: life-cycle
  override func viewDidLoad() {
    configurator?.configure(self)
    super.viewDidLoad()
    setupUIContent()
  }
  
  
  // NARK: render ui content
  private func setupUIContent() {
    lblPageTitle.hero.isEnabled = true
    lblPageTitle.hero.modifiers = [.scale()]
    scrollView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    
    setTextViewParams(in: ftEmail, with: InputItemType.email.rawValue, keyboard: .emailAddress, nextView: ftPassword)
    setTextViewParams(in: ftPassword, with: InputItemType.password.rawValue, nextView: ftConfirmPassword)
    setTextViewParams(in: ftConfirmPassword, with: InputItemType.confirmPassword.rawValue, nextView: ftFirstName)
    setTextViewParams(in: ftFirstName, with: InputItemType.firstName.rawValue, nextView: ftLastName)
    setTextViewParams(in: ftLastName, with: InputItemType.lastName.rawValue, nextView: ftPhoneNumber)
    setTextViewParams(in: ftPhoneNumber, with: InputItemType.phoneNumber.rawValue, keyboard: .phonePad,
                      nextView: ftCity)
    setTextViewParams(in: ftCity, with: InputItemType.city.rawValue, nextView: ftStreet)
    setTextViewParams(in: ftStreet, with: InputItemType.street.rawValue, nextView: ftHouse)
    setTextViewParams(in: ftHouse, with: InputItemType.house.rawValue, nextView: ftApartment)
    setTextViewParams(in: ftApartment, with: InputItemType.apartment.rawValue, keyboard: .asciiCapableNumberPad)
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
  @IBAction func clickedClose(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func clickedRegister(_ sender: Any) {
    self.props.actionRegister.perform()
  }
}


// swiftlint:disable cyclomatic_complexity
extension SignUpViewController: FormTextItemViewDelegate {
  
  func didChangeFormText(view: FormTextItemView, at text: String?) {
    guard let inputItemType = InputItemType(rawValue: view.identifier) else { return }
    switch inputItemType {
    case .email:
      props.email.change.perform(with: text)
    case .password:
      props.password.change.perform(with: text)
    case .confirmPassword:
      props.confirmPassword.change.perform(with: text)
    case .firstName:
      props.firstName.change.perform(with: text)
    case .lastName:
      props.lastName.change.perform(with: text)
    case .phoneNumber:
      props.phoneNumber.change.perform(with: text)
    case .city:
      props.city.change.perform(with: text)
    case .street:
      props.street.change.perform(with: text)
    case .house:
      props.house.change.perform(with: text)
    case .apartment:
      props.apartment.change.perform(with: text)
    }
  }
}
