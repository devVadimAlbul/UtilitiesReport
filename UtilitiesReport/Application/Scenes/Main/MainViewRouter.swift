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
    func pushToEditUserProfile(_ user: UserProfile)
}

class MainViewRouterImpl: MainViewRouter {
    
    fileprivate weak var viewController: MainViewController?
    
    init(viewController: MainViewController) {
        self.viewController = viewController
    }
    
    func pushToEditUserProfile(_ user: UserProfile) {
        let viewController = UserFormViewController()
        viewController.configurator = UserFormConfiguratorImpl(userProfile: user)
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
}
