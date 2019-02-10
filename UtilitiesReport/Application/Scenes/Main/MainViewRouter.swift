//
//  MainViewRouter.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/9/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol MainViewRouter {
    func presentUserForm()
}

class MainViewRouterImpl: MainViewRouter {
    
    fileprivate weak var viewController: MainViewController?
    
    init(viewController: MainViewController) {
        self.viewController = viewController
    }
    
    func presentUserForm() {
        let vc = UserFormViewController()
        vc.configurator = UserFormConfiguratorImpl(userProfile: nil)
        self.viewController?.present(vc, animated: true, completion: nil)
//    self.viewController?.navigationController?.showDetailViewController(vc, sender: nil)
    }
}
