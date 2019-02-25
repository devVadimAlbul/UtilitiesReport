//
//  WelcomeConfigurator.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/21/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol WelcomeConfigurator {
    func configure(viewController: WelcomeViewController) 
}

class WelcomeConfiguratorImpl: WelcomeConfigurator {
    
    func configure(viewController: WelcomeViewController) {
        let router = WelcomeViewRoulerImpl(viewController: viewController)
        let presenter = WelcomePresenterImpl(view: viewController, router: router)
        viewController.presneter = presenter
    }
}
