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
    func changeFormItem(value: String?, by identifier: String)
    func saveFormContent() 
}

class UserFormPresenterImpl: UserFormPresenter {
    
    // MARK: property
    fileprivate var userProfile: UserProfile!
    fileprivate weak var viewForm: UserFormView?
    fileprivate var isUserCreated: Bool = false
    fileprivate var saveUserProfile: SaveUserProfileUseCase!
    var router: UserFormViewRouter
    
    init(view: UserFormView,
         router: UserFormViewRouter,
         profile: UserProfile?,
         saveUserProfile: SaveUserProfileUseCase) {
        self.router = router
        self.viewForm = view
        self.saveUserProfile = saveUserProfile
        
        if let profile = profile {
            self.userProfile = profile
            isUserCreated = true
        } else {
            userProfile = UserProfile()
            isUserCreated = false
        }
    }
    // MARK: UserFormPresenter methods
    func viewDidLoad() {
        let title = isUserCreated ? "Edit User" : "Create New User"
        viewForm?.displayPageTitle(title)
        displayFormItems()
    }
    
    func changeFormItem(value: String?, by identifier: String) {
        userProfile.setValue(value, forKey: identifier)
    }
    
    func saveFormContent()  {
        let invalidItems = userProfile.checkValidContent()
        if invalidItems.isEmpty {
            saveUserProfile.save(user: userProfile) { [weak self] (result) in
                guard let `self` = self else { return }
                switch result {
                case .success(_): self.viewForm?.displaySuccessSave()
                case .failure(let error): self.viewForm?.displayError(message: error.localizedDescription)
                }
            }
        } else {
            invalidItems.forEach {
                self.viewForm?.updateFormItem(id: $0, isValid: false)
            }
        }
    }
    
    // MARK: display methods
    func displayFormItems() {
        let model = userProfile.generateFormModelView()
        viewForm?.displayForm(model)
    }

    

}
