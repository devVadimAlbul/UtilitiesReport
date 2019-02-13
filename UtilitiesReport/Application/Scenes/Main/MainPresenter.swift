//
//  MainPresenter.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/9/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

enum TypeCellForMainView: Int {
    case userProfileCell = 0
}

protocol MainPresenter: PresenterProtocol {
    var router: MainViewRouter { get }
    func loadContent()
    var numberOfSections: Int { get }
    func numberOfRows(in section: Int) -> Int
    func cellType(at indexPath: IndexPath) -> TypeCellForMainView?
    func configure(cellView: BasicVeiwCellProtocol, for indexPath: IndexPath)
    func didSelectCell(at indexPath: IndexPath)
}

class MainPresenterImpl: MainPresenter {
    
    // MARK: property
    fileprivate weak var mainView: MainView?
    var router: MainViewRouter
    fileprivate var loadUserProfile: LoadUserProfileUseCase
    fileprivate var userProfile: UserProfile?
    
    // MARK: init
    init(view: MainView,
         router: MainViewRouter,
         loadUserProfile: LoadUserProfileUseCase) {
        self.mainView = view
        self.router = router
        self.loadUserProfile = loadUserProfile
    }
    
    // MARK: MainPresenter Methods
    func viewDidLoad() {
        mainView?.displayPageTitle("Utilities Report")
    }
    
    func loadContent() {
        checkUserCreated()
    }
    
    fileprivate func checkUserCreated() {
        loadUserProfile.load { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success(let user):
                if let user = user {
                    self.userProfile = user
                    self.mainView?.updateUIContent()
                }
            case .failure(let error):
                self.mainView?.displayError(message: error.localizedDescription)
            }
        }
    }
    
    // MARK: configurate tableview
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        switch section {
        case 0: return userProfile == nil ? 0 : 1
        default: return 0
        }
    }
    
    func cellType(at indexPath: IndexPath) -> TypeCellForMainView? {
        let type = TypeCellForMainView(rawValue: indexPath.section)
        return type
    }
    
    func configure(cellView: BasicVeiwCellProtocol, for indexPath: IndexPath) {
        if let cell = cellView as? UserProfileViewCell {
            configureUserProfile(cell: cell)
        }
    }
    
    fileprivate func configureUserProfile(cell: UserProfileViewCell) {
        guard let user = self.userProfile else { return }
        cell.display(name: user.name)
        cell.display(phoneNumber: user.phoneNumber)
        cell.display(address: user.address)
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        guard let type = TypeCellForMainView(rawValue: indexPath.section) else { return }
        switch type {
        case .userProfileCell:
            if let user = userProfile {
                router.pushToEditUserProfile(user)
            }
        }
    }
  
}
