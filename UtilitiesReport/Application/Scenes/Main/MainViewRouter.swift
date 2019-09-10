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
    func pushListIndicators(userCounterID: String)
    func pushToFormUserCompany(uaerCompany: UserUtilitiesCompany?)
    func showAlert(by model: AlertModelView)
    func showErrorAlert(message: String, completionHandler: (() -> Void)?)
    func goToWelcomePage()
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
    
    func pushToFormUserCompany(uaerCompany: UserUtilitiesCompany? = nil) {
        let viewController = FormUserUtilitesCompanyViewController()
        viewController.configurator = FormUserUtilitesCompanyConfiguratorImpl(userUtitlitesCompany: uaerCompany)
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushListIndicators(userCounterID: String) {
        let listVC = ListIndicatorsCounterViewController()
        listVC.configurator = ListIndicatorsCounterConfiguratorImpl(userCompanyIdentifier: userCounterID)
        self.viewController?.navigationController?.pushViewController(listVC, animated: true)
    }
  
    func showAlert(by model: AlertModelView) {
        viewController?.presentAlert(by: model)
    }
  
    func showErrorAlert(message: String, completionHandler: (() -> Void)? = nil) {
      viewController?.showErrorAlert(message: message, completionHandler: {_ in completionHandler?()})
    }
  
    func goToWelcomePage() {
      AppDelegate.shared.presenter.router.goToWelcomePage()
    }
}
