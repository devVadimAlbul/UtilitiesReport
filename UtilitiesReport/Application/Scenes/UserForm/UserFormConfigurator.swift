//
//  UserFormConfigurator.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/10/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol UserFormConfigurator {
    func configure(view: UserFormViewController)
}

class UserFormConfiguratorImpl: UserFormConfigurator {
    let userProfile: UserProfile?
    
    init(userProfile: UserProfile?) {
        self.userProfile = userProfile
    }
    
    func configure(view: UserFormViewController) {
        let router = UserFormViewRouterImpl(viewController: view)
        let saveUseCase = SaveUserProfileUseCaseImpl(storage: DefaultsStorageImpl())
        let presenter = UserFormPresenterImpl(view: view, router: router, profile: userProfile, saveUserProfile: saveUseCase)
        
        view.presneter = presenter
    }
}
