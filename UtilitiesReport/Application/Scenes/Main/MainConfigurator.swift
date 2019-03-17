//
//  MainConfiguration.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/9/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit.UITableView

protocol MainConfigurator {
    func configure(viewController: MainViewController)
}

class MainConfiguratorImpl: MainConfigurator {
    
    func configure(viewController: MainViewController) {
        let router = MainViewRouterImpl(viewController: viewController)
        let loadUserUseCase = LoadUserProfileUseCaseImpl(storage: UserProfileLocalStorageGatewayImpl())
        let storage = UserUtilCompanyLocalStorageGatewayImpl.default
        let loadUserCompanies = LoadUserCompaniesUseCaseImpl(
            gateway: UserUtilitesCompanyGatewayImpl(localStorage: storage)
        )
        let presenter = MainPresenterImpl(view: viewController, router: router,
                                          loadUserProfile: loadUserUseCase,
                                          loadUserCompanies: loadUserCompanies)
        viewController.presenter = presenter
    }
}
