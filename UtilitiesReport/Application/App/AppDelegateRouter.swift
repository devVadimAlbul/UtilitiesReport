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
        goToViewController(mainVC)
    }
    
    func goToCreatedUserProfile() {
        let userFormVC = UserFormViewController()
        userFormVC.configurator = UserFormConfiguratorImpl(userProfile: nil)
        goToViewController(userFormVC)
    }
    
    fileprivate func goToViewController(_ viewController: UIViewController) {
        let window = appDelegate?.window
        let navigation = VCLoader<UINavigationController>.loadInitial(storyboardId: .navigation)
        navigation.viewControllers = [viewController]
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
}
