//
//  AppDelegateRouter.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/13/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit.UIWindow
import UIKit.UINavigationController
import Hero

protocol AppDelegateRouter: AnyObject {
  func showFakeSpleashScreen()
  func goToMainViewController()
  func goToWelcomePage()
}

class AppDelegateRouterImpl: AppDelegateRouter {
  fileprivate weak var appDelegate: AppDelegate?
  
  init(delegate: AppDelegate) {
    self.appDelegate = delegate
  }
  
  func goToMainViewController() {
    let mainVC = MainViewController()
    mainVC.configurator = MainConfiguratorImpl()
    let navigation = VCLoader<UINavigationController>.loadInitial(storyboardId: .navigation)
    navigation.viewControllers = [mainVC]
    goToViewController(navigation)
  }
  
  func goToWelcomePage() {
    let welcomeVC = WelcomeViewController()
    welcomeVC.configurator = WelcomeConfiguratorImpl()
    welcomeVC.view.hero.modifiers = [.translate(y:100)]
    goToViewController(welcomeVC)
  }
  
  func showFakeSpleashScreen() {
    let spleash = FakeSpleashViewController()
    goToViewController(spleash)
  }
  
  fileprivate func goToViewController(_ viewController: UIViewController) {
    guard let window = appDelegate?.window else { return }
    viewController.hero.isEnabled = true
    UIView.transition(with: window, duration: 0.5, options: .showHideTransitionViews, animations: {
      window.rootViewController = viewController
    }, completion: { finished in
//      if finished {
        window.makeKeyAndVisible()
//      }
    })
  }
}
