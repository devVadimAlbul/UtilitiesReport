import UIKit

protocol LoginView: AnyObject {
  
}

class LoginViewController: BasicViewController, LoginView {
  
  // MARK: property
  var configurator: LoginViewConfigurator!
  private var loginPresenter: LoginViewPresenter? {
    return presenter as? LoginViewPresenter
  }
  
  override func viewDidLoad() {
    configurator?.configure(self)
    super.viewDidLoad()
  }
  

}
