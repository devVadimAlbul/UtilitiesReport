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
    fileprivate var loadUserProfile: LoadUserProfileUseCase
    
    init(view: MainView,
         router: MainViewRouter,
         loadUserProfile: LoadUserProfileUseCase) {
        self.view = view
        self.router = router
        self.loadUserProfile = loadUserProfile
    }
    
    func viewDidLoad() {
        checkUserCreated()
    }
    
    func checkUserCreated() {
        loadUserProfile.load { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success(let user):
                if user == nil {
                    self.router.presentUserForm()
                }
            case .failure(let error):
                print("[MainPresenter] load user profile error: ", error)
            }
        }
    }
    
  
}
