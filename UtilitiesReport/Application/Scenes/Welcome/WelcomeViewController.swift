import UIKit

protocol WelcomeView: AnyObject {
  
}

class WelcomeViewController: BasicViewController, WelcomeView {
  
  // MARK: IBOutlet
  @IBOutlet weak var lblTitle: UILabel!
  @IBOutlet weak var btnSignIn: ButtonRound!
  @IBOutlet weak var btnSignUp: ButtonRound!
  @IBOutlet weak var lblDescription: UILabel!
  
  // MARK: property
  var configurator: WelcomeConfigurator!
  var welcomePresenter: WelcomePresenter? {
    return presenter as? WelcomePresenter
  }
  
  // MARK: life-cycle
  override func viewDidLoad() {
    configurator.configure(viewController: self)
    super.viewDidLoad()
    //        FirebaseHelper.shared.auth(email: "test.acount.app@gmail.com", password: "acount241")
  }
  
  // MARK: IBAction
  @IBAction func clickedSignIn(_ sender: UIButton) {
    welcomePresenter?.router.presentSingIn()
  }
  
  @IBAction func clickedSignUp(_ sender: UIButton) {
    welcomePresenter?.router.presentSingUp()
  }
}
