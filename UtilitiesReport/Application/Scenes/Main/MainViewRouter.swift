//
//  MainViewRouter.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/9/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit.UINavigationController

protocol MainViewRouter {
    func presentNewUserForm()
    func pushToEditUserProfile(_ user: UserProfile)
}

class MainViewRouterImpl: MainViewRouter {
    
    fileprivate weak var viewController: MainViewController?
    
    init(viewController: MainViewController) {
        self.viewController = viewController
    }
    
    func presentNewUserForm() {
        let vc = UserFormViewController()
        vc.configurator = UserFormConfiguratorImpl(userProfile: nil)
        self.viewController?.navigationPresent(vc, animated: true, isNeedClose: false)
    }
    
    func pushToEditUserProfile(_ user: UserProfile) {
        let vc = UserFormViewController()
        vc.configurator = UserFormConfiguratorImpl(userProfile: user)
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
