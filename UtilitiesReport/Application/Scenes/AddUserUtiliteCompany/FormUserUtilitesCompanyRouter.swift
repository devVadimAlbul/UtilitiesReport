//
//  AddUserUtilitesCompanyRouter.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/3/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol FormUserUtilitesCompanyRouter {
    
}

class FormUserUtilitesCompanyRouterImpl: FormUserUtilitesCompanyRouter {
    
    private weak var viewController: FormUserUtilitesCompanyViewController?
    
    init(viewController: FormUserUtilitesCompanyViewController) {
        self.viewController = viewController
    }
}
