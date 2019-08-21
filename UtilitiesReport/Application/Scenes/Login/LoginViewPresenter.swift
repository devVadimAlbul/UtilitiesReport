import Foundation

protocol LoginViewPresenter: PresenterProtocol {
  var router: LoginViewRouter { get set }
}

class LoginViewPresenterImpl: LoginViewPresenter {
  
  private weak var view: LoginView?
  var router: LoginViewRouter
  
  init(view: LoginView, router: LoginViewRouter) {
    self.view = view
    self.router = router
  }
  
  func viewDidLoad() {
    
  }
}
