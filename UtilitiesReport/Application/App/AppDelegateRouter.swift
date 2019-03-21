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

protocol AppDelegateRouter: AnyObject {
    func showFakeSpleashScreen()
    func goToMainViewController()
    func goToCreatedUserProfile()
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
    
    func goToCreatedUserProfile() {
        let welcomeVC = WelcomeViewController()
        welcomeVC.configurator = WelcomeConfiguratorImpl()
        goToViewController(welcomeVC)
    }
    
    func showFakeSpleashScreen() {
        let spleash = FakeSpleashViewController()
        goToViewController(spleash)
    }
    
    fileprivate func goToViewController(_ viewController: UIViewController) {
        let window = appDelegate?.window
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}
