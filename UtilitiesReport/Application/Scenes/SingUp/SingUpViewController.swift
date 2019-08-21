import UIKit

protocol SingUpView: AnyObject {
  var configurator: SingUpViewConfigurator! { get set }
  var props: SingUpViewController.Props { get set }
}

class SingUpViewController: BasicViewController, SingUpView {
  
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
  var configurator: SingUpViewConfigurator!
  private var singUpPresenter: SingUpViewPresenter? {
    return presenter as? SingUpViewPresenter
  }
  var props: SingUpViewController.Props = .initial {
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
  
  private func render(props: Props) {
    self.navigationItem.title = props.pageTitle
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
    switch item.state {
    case .valid:
      textView.isValid = true
    case .invalid(message: let message):
      textView.warningMessage = message
      textView.isValid = false
    }
    updateTextIfNeeded(in: textView, with: item, using: \.value)
  }
  
  private func updateTextIfNeeded<T>(in textView: FormTextItemView,
                                     with source: T,
                                     using keyPath: KeyPath<T, String?>) {
    guard !textView.tfItem.isFirstResponder else { return }
    textView.value = source[keyPath: keyPath]
  }
  
  private func updatePageState(_ state: Props.PropsState) {
      switch state {
      case .edit: ProgressHUD.dismiss()
      case .falied(error: let error):
        ProgressHUD.dismiss()
        showErrorAlert(message: error)
      case .loading:
        ProgressHUD.show(message: "Loading...")
      case .success:
        ProgressHUD.success("Save success!", withDelay: 0.5)
      }
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
extension SingUpViewController: FormTextItemViewDelegate {
  
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
