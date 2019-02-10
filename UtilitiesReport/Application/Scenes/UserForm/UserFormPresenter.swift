//
//  UserFormPresenter.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/10/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol UserFormPresenter: PresenterProtocol {
    var router: UserFormViewRouter { get }
}

class UserFormPresenterImpl: UserFormPresenter {
    fileprivate var userProfile: UserProfile!
    fileprivate weak var viewForm: UserFormView?
    fileprivate var isUserCreated: Bool = false
    var router: UserFormViewRouter
    
    init(view: UserFormView,
         router: UserFormViewRouter,
         profile: UserProfile?) {
        self.router = router
        self.viewForm = view
        
        if let profile = userProfile {
            self.userProfile = profile
            isUserCreated = true
        } else {
            userProfile = UserProfile()
            isUserCreated = false
        }
    }

    func viewDidLoad() {
        let title = isUserCreated ? "Edit User" : "Create New User"
        viewForm?.displayPageTitle(title)
    }
}
