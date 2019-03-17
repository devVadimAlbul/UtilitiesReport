//
//  MainPresenter.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/9/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit.UIImage

enum TypeCellForMainView {
    case userProfileCell
    case listUserCompaniesCell
    case emptyListUserCompaniesCell
}

protocol MainPresenter: PresenterProtocol {
    var router: MainViewRouter { get }
    func loadContent()
    func actionAddNew()
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
    fileprivate var loadUserCompanies: LoadUserCompaniesUseCase
    
    fileprivate var userProfile: UserProfile?
    fileprivate var companies: [UserUtilitiesCompany] = []
    
    // MARK: init
    init(view: MainView,
         router: MainViewRouter,
         loadUserProfile: LoadUserProfileUseCase,
         loadUserCompanies: LoadUserCompaniesUseCase) {
        self.mainView = view
        self.router = router
        self.loadUserProfile = loadUserProfile
        self.loadUserCompanies = loadUserCompanies
    }
    
    // MARK: MainPresenter Methods
    func viewDidLoad() {
        mainView?.displayPageTitle("Utilities Report")
    }
    
    func loadContent() {
        checkUserCreated()
        loadListUserCompanies()
    }
    
    fileprivate func checkUserCreated() {
        loadUserProfile.load { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success(let user):
                self.userProfile = user
                self.mainView?.updateUIContent()
            case .failure(let error):
                self.mainView?.displayError(message: error.localizedDescription)
            }
        }
    }
    
    fileprivate func loadListUserCompanies() {
        loadUserCompanies.loadList { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success(let companies):
                self.companies = companies
                self.mainView?.updateUIContent()
            case .failure(let error):
                self.mainView?.displayError(message: error.localizedDescription)
            }
        }
    }
    
    func actionAddNew() {
        router.pushToAddUserCompany()
    }
    
    // MARK: configurate tableview
    var numberOfSections: Int {
        return 2
    }
    
    func numberOfRows(in section: Int) -> Int {
        switch section {
        case 0: return userProfile == nil ? 0 : 1
        case 1: return companies.isEmpty ? 1 : companies.count
        default: return 0
        }
    }
    
    func cellType(at indexPath: IndexPath) -> TypeCellForMainView? {
        switch indexPath.section {
        case 0:
            return .userProfileCell
        case 1:
            return companies.isEmpty ? .emptyListUserCompaniesCell : .listUserCompaniesCell
        default:
            return nil
        }
    }
    
    func configure(cellView: BasicVeiwCellProtocol, for indexPath: IndexPath) {
        switch cellView {
        case let cell as UserProfileViewCell:
            configureUserProfile(cell: cell)
        case let cell as EmptyListViewCell:
            cell.delegate = mainView as? AddUserCompanyDelegate
            cell.displayMessage("List utilities company for user is empty.")
            cell.displayNameAddButton("Add new company")
        case let cell as UserCompanyItemViewCell:
            let item = companies[indexPath.row]
            configureUserComanyCell(cell: cell, with: item)
        default: break
        }
    }
    
    fileprivate func configureUserProfile(cell: UserProfileViewCell) {
        guard let user = self.userProfile else { return }
        cell.display(name: user.name)
        cell.display(phoneNumber: user.phoneNumber)
        cell.display(address: user.address)
        cell.display(email: user.email)
    }
    
    private func configureUserComanyCell(cell: UserCompanyItemViewCell,
                                         with userCompany: UserUtilitiesCompany) {
       
        cell.displayName(userCompany.company?.name)
        cell.displayAccountNumber(userCompany.accountNumber)
        cell.displayEmblem(userCompany.company?.type.image ?? CompanyType.default.image)
        cell.displayIndicators(getLastIndicators(in: userCompany))
    }
    
    private func getLastIndicators(in userCompany: UserUtilitiesCompany) -> [LastInticatorModelView] {
        let sortedList = userCompany.indicators.sorted(by: {$0.date.compare($1.date) == .orderedAscending})
        let isNeadCounter = userCompany.company?.isNeedCounter ?? false
        if isNeadCounter {
            let listCounter: [Counter] = userCompany.counters
            let lastCounter = listCounter.compactMap({ counter in
                return sortedList.first(where: {$0.counter?.identifier == counter.identifier})
            })
            let models = lastCounter.map({
                return LastInticatorModelView(name: $0.counter?.placeInstallation,
                                              months: $0.month, value: $0.value)
            })
            return models
        } else {
            if let first = sortedList.first {
                return [LastInticatorModelView(name: first.counter?.placeInstallation,
                                               months: first.month, value: first.value)]
            }
        }
        return []
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if let user = userProfile {
                router.pushToEditUserProfile(user)
            }
        case 1:
            if companies.count > indexPath.row {
                let item = companies[indexPath.row]
                router.pushListIndicators(userCounterID: item.accountNumber)
            }
        default:
            break
        }
    }
  
}
