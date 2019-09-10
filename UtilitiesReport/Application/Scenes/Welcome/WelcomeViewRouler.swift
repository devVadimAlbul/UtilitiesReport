//
//  WelcomeRouler.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/21/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit.UINavigationController
import Hero

protocol WelcomeViewRouler {
  func presentSingUp()
  func presentSingIn()
}

class WelcomeViewRoulerImpl: WelcomeViewRouler {
  
  fileprivate weak var viewController: WelcomeViewController?
  
  init(viewController: WelcomeViewController) {
    self.viewController = viewController
  }
  
  func presentSingUp() {
    let singUpVC = SignUpViewController()
    singUpVC.configurator = SignUpViewConfiguratorImpl()
    singUpVC.hero.isEnabled = true
    singUpVC.hero.modalAnimationType = .selectBy(presenting: .fade,
                                                 dismissing: .zoomOut)
    viewController?.present(singUpVC, animated: true, completion: nil)
  }
  
  func presentSingIn() {
    let login = LoginViewController()
    login.configurator = LoginViewConfiguratorImpl()
    login.hero.isEnabled = true
    login.hero.modalAnimationType = .selectBy(presenting: .fade,
                                              dismissing: .zoomOut)
    viewController?.present(login, animated: true, completion: nil)
  }
}
