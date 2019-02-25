//
//  UserFormViewRouter.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/10/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol UserFormViewRouter {
    func goToMainPage()
}

class UserFormViewRouterImpl: UserFormViewRouter {
    fileprivate weak var viewController: UserFormViewController?
    
    init(viewController: UserFormViewController) {
        self.viewController = viewController
    }
    
    func goToMainPage() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            if let navigation = self.viewController?.navigationController,
                let main = navigation.getViewControllerInStack(MainViewController.self) {
                navigation.popToViewController(main, animated: true)
            } else {
                AppDelegate.shared.presenter.router.goToMainViewController()
            }
        }
    }
}
