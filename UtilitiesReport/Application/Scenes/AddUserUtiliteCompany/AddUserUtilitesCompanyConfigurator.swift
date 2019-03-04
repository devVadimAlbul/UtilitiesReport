//
//  AddUserUtilitesCompanyConfigurator.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/3/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol FormUserUtilitesCompanyConfigurator {
    func configure(viewController: FormUserUtilitesCompanyViewController)
}

class FormUserUtilitesCompanyConfiguratorImpl: FormUserUtilitesCompanyConfigurator {
    
    func configure(viewController: FormUserUtilitesCompanyViewController) {
        let router = FormUserUtilitesCompanyRouterImpl(viewController: viewController)
        let presenter = FormUserUtilitesCompanyPresenterImpl(view: viewController, router: router)
        
        viewController.presneter = presenter
    }
}
