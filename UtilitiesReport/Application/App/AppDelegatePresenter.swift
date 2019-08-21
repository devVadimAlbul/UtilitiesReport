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
import Firebase

protocol AppDelegatePresenter {
    var router: AppDelegateRouter { get set }
    func didFinishLaunching()
}

class AppDelegatePresenterImpl: AppDelegatePresenter {
 
    fileprivate let userUseCase: LoadUserProfileUseCase
    fileprivate weak var appDelegate: AppDelegateProtocol?
    var router: AppDelegateRouter
    
    init(appDelegate: AppDelegateProtocol,
         router: AppDelegateRouter,
         userUseCase: LoadUserProfileUseCase) {
        self.appDelegate = appDelegate
        self.router = router
        self.userUseCase = userUseCase
    }
    
    func didFinishLaunching() {
        ProgressHUD.configure()
        IQKeyboardManager.shared.enable = true
 
        RealmManager.setConfiguration()
        router.showFakeSpleashScreen()
        checkSavedUserProfile()
    }
    
    fileprivate func checkSavedUserProfile() {
        userUseCase.load { [weak self] (result) in
            guard let `self` = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now()+3.0) {
                switch result {
                case .success:
                    self.router.goToMainViewController()
                case .failure:
                    self.router.goToWelcomePage()
                }
            }
        }
    }
}
