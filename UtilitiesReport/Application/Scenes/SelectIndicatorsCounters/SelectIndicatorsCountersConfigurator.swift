//
//  SelectIndicatorsCountersConfigurator.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 4/27/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol SelectIndicatorsCountersConfigurator {
    func configure(viewController: SelectIndicatorsCountersViewController)
}

class SelectIndicatorsCountersConfiguratorImpl: SelectIndicatorsCountersConfigurator {
    
    private let seletedIndicator: IndicatorsCounter
    private let userUntilitesCompany: UserUtilitiesCompany

    init(seletedIndicator: IndicatorsCounter, userUntilitesCompany: UserUtilitiesCompany) {
        self.seletedIndicator = seletedIndicator
        self.userUntilitesCompany = userUntilitesCompany
    }
    
    func configure(viewController: SelectIndicatorsCountersViewController) {
        let router = SelectIndicatorsCountersRouterImpl(viewController: viewController)

        let presenter = SelectIndicatorsCountersPresenterImpl(view: viewController,
                                                              router: router,
                                                              selectedIndicator: seletedIndicator,
                                                              userUntilitesCompany: userUntilitesCompany)
        
        viewController.presenter = presenter
    }
}
