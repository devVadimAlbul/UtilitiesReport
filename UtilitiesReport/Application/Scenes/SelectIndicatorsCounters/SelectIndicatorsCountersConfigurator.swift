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
    
    func configure(viewController: SelectIndicatorsCountersViewController) {
        let router = SelectIndicatorsCountersRouterImpl(viewController: viewController)

        let presenter = SelectIndicatorsCountersPresenterImpl(view: viewController,
                                                              router: router)
        
        viewController.presenter = presenter
    }
}
