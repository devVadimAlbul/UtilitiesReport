//
//  MainConfiguration.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/9/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol MainConfigurator {
   func configure(viewController: MainViewController)
}

class MainConfiguratorImpl: MainConfigurator {
    
    func configure(viewController: MainViewController) {
        let router = MainViewRouterImpl(viewController: viewController)
        let manager = AccountManager(storage: DefaultsStorageImpl())
        let presenter = MainPresenterImpl(view: viewController, router: router, accountManager: manager)
        viewController.presneter = presenter
    }
}
