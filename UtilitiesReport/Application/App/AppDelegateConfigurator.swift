//
//  AppDelegateConfigurator.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/13/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation


protocol AppDelegateConfigurator: class {
    func configure(delegate: AppDelegate)
}

class AppDelegateConfiguratorImpl: AppDelegateConfigurator {
    
    func configure(delegate: AppDelegate) {
        let userUseCase = GetSavedUserProfileUseCaseImpl(storage: DefaultsStorageImpl())
        let router = AppDelegateRouterImpl(delegate: delegate)
        let presenter = AppDelegatePresenterImpl(appDelegate: delegate, router: router,
                                                 userUseCase: userUseCase)
        delegate.presenter = presenter
    }
}
