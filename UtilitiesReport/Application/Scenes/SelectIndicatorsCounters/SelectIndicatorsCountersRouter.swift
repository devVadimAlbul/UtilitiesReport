//
//  SelectIndicatorsCountersViewRouter.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 4/27/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit.UIViewController

protocol SelectIndicatorsCountersRouter {
    
}

class SelectIndicatorsCountersRouterImpl: SelectIndicatorsCountersRouter {
    
    private weak var viewController: SelectIndicatorsCountersViewController?
    
    init(viewController: SelectIndicatorsCountersViewController) {
        self.viewController = viewController
    }
}
