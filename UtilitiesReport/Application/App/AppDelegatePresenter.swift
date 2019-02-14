//
//  AddDelegateConfigure.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/13/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift

protocol AppDelegatePresenter {
    var router: AppDelegateRouter { get set }
    func didFinishLaunching()
}

class AppDelegatePresenterImpl: AppDelegatePresenter {
 
    fileprivate let userUseCase: GetSavedUserProfileUseCase
    fileprivate weak var appDelegate: AppDelegateProtocol?
    var router: AppDelegateRouter
    
    init(appDelegate: AppDelegateProtocol,
         router: AppDelegateRouter,
         userUseCase: GetSavedUserProfileUseCase) {
        self.appDelegate = appDelegate
        self.router = router
        self.userUseCase = userUseCase
    }
    
    func didFinishLaunching() {
        ProgressHUD.configure()
        IQKeyboardManager.shared.enable = true
        checkSavedUserProfile()
    }
    
    fileprivate func checkSavedUserProfile() {
        let identifier = Constants.StoregeKeys.userProfile
        if let user = try? userUseCase.getUserProfile(identifier: identifier),
            user.firstName != "", user.lastName != "" {
            router.goToMainViewController()
        } else {
            router.goToCreatedUserProfile()
        }
    }
}
