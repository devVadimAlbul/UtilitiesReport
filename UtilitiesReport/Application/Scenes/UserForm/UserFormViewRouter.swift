//
//  UserFormViewRouter.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/10/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol UserFormViewRouter {
    
}

class UserFormViewRouterImpl: UserFormViewRouter {
    fileprivate weak var viewController: UserFormViewController?
    
    init(viewController: UserFormViewController) {
        self.viewController = viewController
    }
}
