//
//  FormIndicatorCounterConfigurator.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/16/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol FormIndicatorCounterConfigurator {
    func configure(viewController: FormIndicatorCounterViewController)
}

class FormIndicatorCounterConfiguratorImpl: FormIndicatorCounterConfigurator {
    
    private var indicator: IndicatorsCounter
    private var userUntilitesCompany: UserUtilitiesCompany
    init(indicator: IndicatorsCounter, userUntilitesCompany: UserUtilitiesCompany) {
        self.indicator = indicator
        self.userUntilitesCompany = userUntilitesCompany
    }
    
    func configure(viewController: FormIndicatorCounterViewController) {
        let router = FormIndicatorCounterViewRouterImpl(viewController: viewController)
        let indicatorGateway = IndicatorsCouterLocalStorageGatewayImpl(manager: RealmManager())
        let presenter = FormIndicatorCounterPresenterImpl(router: router,
                                                          view: viewController,
                                                          indicator: indicator,
                                                          userUntilitesCompany: userUntilitesCompany,
                                                          indicatorGateway: indicatorGateway)
        viewController.presenter = presenter
    }
}
