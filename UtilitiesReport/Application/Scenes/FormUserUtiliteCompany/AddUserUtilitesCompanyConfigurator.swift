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
    
    private var userUtitlitesCompany: UserUtilitiesCompany?
    
    init(userUtitlitesCompany: UserUtilitiesCompany? = nil) {
        self.userUtitlitesCompany = userUtitlitesCompany
    }
    
    func configure(viewController: FormUserUtilitesCompanyViewController) {
        let router = FormUserUtilitesCompanyRouterImpl(viewController: viewController)
        let apiGateway = FirebaseCompaniesGatewayImpl()
        let manager = RealmManager()
        
        let localStorageCompany = CompaniesLocalStorageGatewayImpl(manager: manager)
        let companiesGateway = CompaniesGatewayImpl(api: apiGateway, localStorage: localStorageCompany)
        
        let localStorageUserComapny = UserUtilCompanyLocalStorageGatewayImpl(manager: manager)
        let userComapnyGateway = UserUtilitesCompanyGatewayImpl(localStorage: localStorageUserComapny)
        
        let presenter = FormUserUtilitesCompanyPresenterImpl(view: viewController,
                                                             router: router,
                                                             userUtitlitesCompany: userUtitlitesCompany,
                                                             companiesGateway: companiesGateway,
                                                             userCompanyGateway: userComapnyGateway)
        viewController.presenter = presenter
    }
}
