//
//  ListIndicatorsCounterRouter.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/14/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol ListIndicatorsCounterRouter {
    
}

class ListIndicatorsCounterRouterImpl: ListIndicatorsCounterRouter {
    
    private weak var viewController: ListIndicatorsCounterViewController?
    
    init(viewController: ListIndicatorsCounterViewController) {
        self.viewController = viewController
    }
    
    
}
