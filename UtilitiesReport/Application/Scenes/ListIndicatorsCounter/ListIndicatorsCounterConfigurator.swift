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
        let router = ListIndicatorsCounterRouterImpl(viewController: viewController)
        let indicatorsCounterGateway = IndicatorsCouterLocalStorageGatewayImpl()
        let findUseCase = FindIndicatorsCounterUseCaseImpl(manager: RealmManager())
        let presenter = ListIndicatorsCounterPresenterImpl(router: router,
                                                           view: viewController,
                                                           userCompanyIdentifier: userCompanyIdentifier,
                                                           indicatorsCouterGateway: indicatorsCounterGateway,
                                                           findUseCase: findUseCase)
        
        viewController.presneter = presenter
    }
}
