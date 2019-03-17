//
//  FormIndicatorCounterViewRouter.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/16/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol FormIndicatorCounterViewRouter {
    
}

class FormIndicatorCounterViewRouterImpl: FormIndicatorCounterViewRouter {
    
    private weak var viewController: FormIndicatorCounterViewController?
    
    init(viewController: FormIndicatorCounterViewController?) {
        self.viewController = viewController
    }
}
