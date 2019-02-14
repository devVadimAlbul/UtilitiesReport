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
        let loadUseCase = LoadUserProfileUseCaseImpl(storage: UserProfileLocalStorageGatewayImpl())
        let presenter = MainPresenterImpl(view: viewController, router: router, loadUserProfile: loadUseCase)
        viewController.presneter = presenter
    }
}
