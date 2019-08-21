//
//  WelcomeRouler.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/21/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit.UINavigationController

protocol WelcomeViewRouler {
    func presentUserForm()
}

class WelcomeViewRoulerImpl: WelcomeViewRouler {
    
    fileprivate weak var viewController: WelcomeViewController?
    
    init(viewController: WelcomeViewController) {
        self.viewController = viewController
    }
    
    func presentUserForm() {
//        let userFormVC = UserFormViewController()
//        userFormVC.configurator = UserFormConfiguratorImpl(userProfile: nil)
//        let navigation = VCLoader<UINavigationController>.loadInitial(storyboardId: .navigation)
//        navigation.viewControllers = [userFormVC]
//        viewController?.present(navigation, animated: true, completion: nil)
      let singUpVC = SingUpViewController()
      singUpVC.configurator = SingUpViewConfiguratorImpl()
      viewController?.present(singUpVC, animated: true, completion: nil)
    }
}
