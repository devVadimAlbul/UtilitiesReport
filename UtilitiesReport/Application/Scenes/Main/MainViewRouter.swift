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
    func pushToTextRecognizer(with image: UIImage, delegate: TextRecognizerImageDelegate)
    func pushToAddUserCompany()
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
    
    func pushToTextRecognizer(with image: UIImage, delegate: TextRecognizerImageDelegate) {
        let viewController = TextRecognizerImageViewController()
        viewController.delegate = delegate
        viewController.configurator = TextRecognizerImageConfiguratorImpl(image: image)
        self.viewController?.navigationController?.pushViewController(viewController, animated: false)
    }
    
    func pushToAddUserCompany() {
        let viewController = FormUserUtilitesCompanyViewController()
        viewController.configurator = FormUserUtilitesCompanyConfiguratorImpl()
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
}
