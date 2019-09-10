//
//  MainPresenter.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/9/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit.UIImage
import UIKit.UIAlertController

enum TypeCellForMainView {
    case userProfileCell
    case listUserCompaniesCell
    case emptyListUserCompaniesCell
}

protocol MainPresenter: PresenterProtocol {
    var router: MainViewRouter { get }
    func loadContent()
    func actionAddNew()
    func actionLogout()
    var numberOfSections: Int { get }
    func numberOfRows(in section: Int) -> Int
    func cellType(at indexPath: IndexPath) -> TypeCellForMainView?
    func configure(cellView: BasicVeiwCellProtocol, for indexPath: IndexPath)
    func didSelectCell(at indexPath: IndexPath)
    func canEditCell(at indexPath: IndexPath) -> Bool
    func actionEditItem(for indexPath: IndexPath)
    func actionDeleteItem(for indexPath: IndexPath)
}

class MainPresenterImpl: MainPresenter {
    
    // MARK: property
    fileprivate weak var mainView: MainView?
    var router: MainViewRouter
    fileprivate var loadUserProfile: LoadUserProfileUseCase
    fileprivate var userCompanyGateway: UserUtilitesCompanyGateway
    
    fileprivate var userProfile: UserProfile!
    fileprivate var companies: [UserUtilitiesCompany] = []
    private var logoutUseCase: LogoutUseCase
    
    // MARK: init
    init(view: MainView,
         router: MainViewRouter,
         loadUserProfile: LoadUserProfileUseCase,
         userCompanyGateway: UserUtilitesCompanyGateway,
         logoutUseCase: LogoutUseCase) {
        self.mainView = view
        self.router = router
        self.loadUserProfile = loadUserProfile
        self.userCompanyGateway = userCompanyGateway
        self.logoutUseCase = logoutUseCase
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
                self.mainView?.displayUserProfile(user)
            case .failure(let error):
              self.router.showErrorAlert(message: error.localizedDescription) { [weak self] in
                self?.router.goToWelcomePage()
              }
            }
        }
    }
    
    fileprivate func loadListUserCompanies() {
        userCompanyGateway.fetch { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success(let companies):
//                self.companies = companies
                self.companies = UserUtilitiesCompany.testItems
                self.mainView?.updateUIContent()
            case .failure(let error):
                self.router.showErrorAlert(message: error.localizedDescription, completionHandler: nil)
            }
        }
    }
    
    func actionAddNew() {
        router.pushToFormUserCompany(uaerCompany: nil)
    }
  
    func actionLogout() {
      let actionItems: [AlertActionModelView] = [
        AlertActionModelView(title: "Yes", action: CommandWith { [weak self] _ in
          self?.logout()
        }),
        AlertActionModelView(title: "No", action: nil)
      ]
      let model = AlertModelView(title: "Are you really want to logout?",
                                 message: nil,
                                 actions: actionItems)
      router.showAlert(by: model)
    }
  
    private func logout() {
      logoutUseCase.logout { [weak self] (result) in
        guard let `self` = self else { return }
        switch result {
        case .success:
          self.router.goToWelcomePage()
        case .failure(let error):
          self.router.showErrorAlert(message: error.localizedDescription, completionHandler: nil)
        }
      }
    }
    
    // MARK: configurate tableview
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
       return companies.isEmpty ? 1 : companies.count
    }
    
    func cellType(at indexPath: IndexPath) -> TypeCellForMainView? {
        return companies.isEmpty ? .emptyListUserCompaniesCell : .listUserCompaniesCell
    }
    
    func configure(cellView: BasicVeiwCellProtocol, for indexPath: IndexPath) {
        switch cellView {
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
    
    private func configureUserComanyCell(cell: UserCompanyItemViewCell,
                                         with userCompany: UserUtilitiesCompany) {
       
        cell.displayName(userCompany.company?.name)
        cell.displayAccountNumber(userCompany.accountNumber)
        cell.displayEmblem(userCompany.company?.type.image ?? CompanyType.default.image)
        cell.displayIndicators(getLastIndicators(in: userCompany))
    }
    
    private func getLastIndicators(in userCompany: UserUtilitiesCompany) -> [LastInticatorModelView] {
        let sortedList = userCompany.indicators.sorted(by: {$0.date.compare($1.date) == .orderedDescending})
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
        if companies.count > indexPath.row {
            let item = companies[indexPath.row]
            router.pushListIndicators(userCounterID: item.accountNumber)
        }
    }
    
    func canEditCell(at indexPath: IndexPath) -> Bool {
        return companies.isEmpty ? false : true
    }
    
    func actionEditItem(for indexPath: IndexPath) {
        if companies.count > indexPath.row {
            let item = companies[indexPath.row]
            router.pushToFormUserCompany(uaerCompany: item)
        }
    }
    
    func actionDeleteItem(for indexPath: IndexPath) {
        if companies.count > indexPath.row {
            let commandDelete = CommandWith<UIAlertAction> { [weak self, indexPath] _ in
                guard let `self` = self else { return }
                self.deleteItem(for: indexPath)
            }
            let title = "Are you sure delete user utilites company?"
            let model = AlertModelView(title: title, message: nil,
                                       actions: [
                                        AlertActionModelView(title: "Yes", action: commandDelete),
                                        AlertActionModelView(title: "No", action: nil)
                ])
            self.router.showAlert(by: model)
        }
    }
    
    private func deleteItem(for indexPath: IndexPath) {
        let item = self.companies[indexPath.row]
        ProgressHUD.show()
        self.userCompanyGateway.delete(entity: item, completionHandler: { [weak self, indexPath] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success:
                ProgressHUD.dismiss()
                self.companies.remove(at: indexPath.row)
                if self.companies.isEmpty {
                    self.mainView?.updateUIContent()
                } else {
                    self.mainView?.removeCell(at: indexPath)
                }
            case let .failure(error):
                self.router.showErrorAlert(message: error.localizedDescription, completionHandler: nil)
            }
            
        })
       
    }
  
}
