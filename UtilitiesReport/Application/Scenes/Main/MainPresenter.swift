//
//  MainPresenter.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/9/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol MainPresenter: PresenterProtocol {
    var router: MainViewRouter { get }

}

class MainPresenterImpl: MainPresenter {
    fileprivate weak var view: MainView?
    var router: MainViewRouter
    fileprivate var accountManager: AccountManager
    
    init(view: MainView,
         router: MainViewRouter,
         accountManager: AccountManager) {
        self.view = view
        self.router = router
        self.accountManager = accountManager
    }
    
    func viewDidLoad() {
        checkUserCreated()
    }
    
    func checkUserCreated() {
        if !accountManager.isUserCreated {
            router.presentUserForm()
        }
    }
}
