//
//  AddUserUtilitesCompanyRouter.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/3/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol FormUserUtilitesCompanyRouter {
    func pressentAlertForm(by model: AlertFormModel,
                           saveComletionHandler: @escaping (AlertFormModel) -> Void)
}

class FormUserUtilitesCompanyRouterImpl: FormUserUtilitesCompanyRouter {
    
    private weak var viewController: FormUserUtilitesCompanyViewController?
    
    init(viewController: FormUserUtilitesCompanyViewController) {
        self.viewController = viewController
    }
    
    func pressentAlertForm(by model: AlertFormModel,
                           saveComletionHandler: @escaping (AlertFormModel) -> Void) {
        AlertFormFieldsViewController.pressentAlertForm(by: model,
                                                        on: viewController,
                                                        saveHandler: saveComletionHandler)
    }
}
