//
//  ListIndicatorsCounterConfigurator.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/14/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol ListIndicatorsCounterConfigurator {
    func configure(viewController: ListIndicatorsCounterViewController)
}

class ListIndicatorsCounterConfiguratorImpl: ListIndicatorsCounterConfigurator {
    
    private var userCompanyIdentifier: String
    
    init(userCompanyIdentifier: String) {
        self.userCompanyIdentifier = userCompanyIdentifier
    }
    
    func configure(viewController: ListIndicatorsCounterViewController) {
        let router = ListIndicatorsCounterRouterImpl(viewController: viewController,
                                                     reportHelper: SendReportHelperImpl())
        
        let indicatorsCounterGateway = IndicatorsCouterLocalStorageGatewayImpl()
        let localStorage = UserUtilCompanyLocalStorageGatewayImpl(manager: RealmManager())
        let companyGateway = UserUtilitesCompanyGatewayImpl(localStorage: localStorage)
        let loadUseCase = LoadUserCompaniesUseCaseImpl(gateway: companyGateway)
        let apiGateway = ApiTemplatesGatewayImpl(apiClient: ApiAlamofireClientImpl())
        let templatesGateway = TemplatesGatewayImpl(apiGateway: apiGateway)
        let formationReportManager = FormationReportManagerImpl()
        
        let presenter = ListIndicatorsCounterPresenterImpl(router: router,
                                                           view: viewController,
                                                           userCompanyIdentifier: userCompanyIdentifier,
                                                           indicatorsCouterGateway: indicatorsCounterGateway,
                                                           loadUseCase: loadUseCase,
                                                           templatesGateway: templatesGateway,
                                                           formationReportManager: formationReportManager)
        
        viewController.presenter = presenter
    }
}
