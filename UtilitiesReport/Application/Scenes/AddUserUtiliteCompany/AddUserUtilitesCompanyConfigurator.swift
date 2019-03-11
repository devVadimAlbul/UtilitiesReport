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
        let apiGateway = ApiCompaniesGatewayImpl(apiClient: ApiClientImpl())
        let localStorage = CompaniesLocalStorageGatewayImpl(manager: RealmManager())
        let companiesGateway = CompaniesGatewayImpl(api: apiGateway, localStorage: localStorage)
        
        let presenter = FormUserUtilitesCompanyPresenterImpl(view: viewController,
                                                             router: router,
                                                             userUtitlitesCompany: nil,
                                                             companiesGateway: companiesGateway)
        viewController.presneter = presenter
    }
}
