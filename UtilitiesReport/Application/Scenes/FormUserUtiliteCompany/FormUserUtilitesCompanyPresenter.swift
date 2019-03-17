//
//  AddUserUtilitesCompanyPresenter.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/3/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol FormUserUtilitesCompanyPresenter: PresenterProtocol {
    var router: FormUserUtilitesCompanyRouter { get set }
    var numberOfSections: Int { get }
    func numberOfRows(in section: Int) -> Int
    func cellType(at indexPath: IndexPath) -> FormUserUtilitesCompanyItemType?
    func configure(cellView: BasicVeiwCellProtocol, for indexPath: IndexPath)
    func isEditingCell(with indexPath: IndexPath) -> Bool
    func changedInputItem(identifier: String?, value: String?)
    func changedSelectItem(identifier: String?, by index: Int)
    func saveUserComapany()
    func getTypeHeaderView(by section: Int) -> FormSectionHeaderType?
    func configure(view: BasicSectionHeaderVeiwProtocol, for section: Int)
    func actionSectionAddView(by identifier: String)
    func actionDeleteItem(by indexPath: IndexPath)
    func actionEditItem(by indexPath: IndexPath)
}

enum FormUserUtilitesCompanyItemType: Int, CaseIterable {
    case accountNumber = 0
    case company = 1
    case counter = 2
    
    var identifier: String {
        switch self {
        case .accountNumber: return "account_number"
        case .company: return "company"
        case .counter: return "counter"
        }
    }
}

enum FormSectionHeaderType: Int {
    case addViewCounter = 2
    
    var identifier: String {
        switch self {
        case .addViewCounter: return "section_add_view_counter"
        }
    }
}

class FormUserUtilitesCompanyPresenterImpl: FormUserUtilitesCompanyPresenter {
    
    // MARK: properties
    var router: FormUserUtilitesCompanyRouter
    
    private weak var formUserCompanyView: FormUserUtilitesCompanyView?
    private var userUtitlitesCompany: UserUtilitiesCompany?
    private var userCompanyGateway: UserUtilitesCompanyGateway
    private var companiesGateway: CompaniesGateway
    private var listCompanies: [Company] = []
    private var isNeedValid: Bool = false
    private var isNeedCounter: Bool = false
    
    init(view: FormUserUtilitesCompanyView,
         router: FormUserUtilitesCompanyRouter,
         userUtitlitesCompany: UserUtilitiesCompany?,
         companiesGateway: CompaniesGateway,
         userCompanyGateway: UserUtilitesCompanyGateway) {
        self.formUserCompanyView = view
        self.router = router
        self.userUtitlitesCompany = userUtitlitesCompany
        self.companiesGateway = companiesGateway
        self.userCompanyGateway = userCompanyGateway
    }
    
    // MARK: load methods
    func viewDidLoad() {
        let title = userUtitlitesCompany == nil ? "Add Utilites Company" : "Edit Utilites Company"
        if userUtitlitesCompany == nil {
            userUtitlitesCompany = UserUtilitiesCompany()
        }
        isNeedCounter = userUtitlitesCompany?.company?.isNeedCounter ?? false
        formUserCompanyView?.displayPageTitle(title)
        loadCompanies()
    }
    
    private func loadCompanies() {
        companiesGateway.fetch { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success(let list):
                self.listCompanies = list
                self.reloadSection(type: .company)
            case .failure(let error):
                self.formUserCompanyView?.displayError(error.localizedDescription)
            }
        }
    }
    
    // MARK: table view cells configure
    private func reloadSection(type: FormUserUtilitesCompanyItemType) {
        let index = type.rawValue
        formUserCompanyView?.reloadSection(index)
    }
    
    var numberOfSections: Int {
        let count = FormUserUtilitesCompanyItemType.allCases.count
        return  isNeedCounter ? count : count - 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        guard let type = FormUserUtilitesCompanyItemType(rawValue: section) else { return 0 }
        switch type {
        case .accountNumber: return 1
        case .company: return 1
        case .counter: return isNeedCounter ? (userUtitlitesCompany?.counters.count ?? 0) : 0
        }
    }
    
    func cellType(at indexPath: IndexPath) -> FormUserUtilitesCompanyItemType? {
        return FormUserUtilitesCompanyItemType(rawValue: indexPath.section)
    }
    
    
    func configure(cellView: BasicVeiwCellProtocol, for indexPath: IndexPath) {
        switch cellView {
        case let cell as InputFormItemViewCell:
            cell.delegate = formUserCompanyView as? InputFormItemDelegate
            if indexPath.section == FormUserUtilitesCompanyItemType.accountNumber.rawValue {
                setAccountNumber(in: cell)
            }
        case let cell as SelectorFormItemViewCell:
            cell.delegate = formUserCompanyView as? SelectorFormItemDelegate
            setCompaniesSelector(in: cell)
        case let cell as InfoFromItemViewCell:
            if indexPath.section == FormUserUtilitesCompanyItemType.counter.rawValue {
                if let counters = userUtitlitesCompany?.counters,
                    counters.count > indexPath.row {
                    let counter = counters[indexPath.row]
                    cell.identifier = counter.identifier
                    cell.displayTitle(counter.placeInstallation)
                    cell.displayDetail(counter.identifier)
                }
            }
        default:
            break
        }
    }
    
    private func setCompaniesSelector(in cell: SelectorFormItemViewCell) {
        guard let userUtitlitesCompany = self.userUtitlitesCompany else { return }
        cell.displayTitle("Company:")
        cell.displayValue(userUtitlitesCompany.company?.name)
        cell.displayPlaceholder("Select comapany")
        let isValid = isNeedValid ? userUtitlitesCompany.company != nil : true
        cell.displayWarningMessage("Company is not selected.", isShow: !isValid)
        let list = listCompanies.map({$0.name})
        let index = listCompanies.firstIndex(where: {
            return $0.identifier == userUtitlitesCompany.company?.identifier
        })
        cell.displayListItems(list, selectedIndex: index)
        cell.identifier = FormUserUtilitesCompanyItemType.company.identifier
    }
    
    private func setAccountNumber(in cell: InputFormItemViewCell) {
        guard let userUtitlitesCompany = self.userUtitlitesCompany else { return }
        cell.displayTitle("Account number:")
        cell.displayPlaceholder("Enter account number")
        cell.displayValue(userUtitlitesCompany.accountNumber)
        cell.setKeyboardType(.numbersAndPunctuation)
        let isValid = isNeedValid ? !userUtitlitesCompany.accountNumber.removeWhiteSpace().isEmpty : true
        cell.displayWarningMessage("Incorrect account number", isShow: !isValid)
        cell.identifier = FormUserUtilitesCompanyItemType.accountNumber.identifier
    }
    
    func isEditingCell(with indexPath: IndexPath) -> Bool {
        guard let type = FormUserUtilitesCompanyItemType(rawValue: indexPath.section) else { return false }
        return type == .counter
    }

    // MARK: changed item methods
    func changedInputItem(identifier: String?, value: String?) {
       if identifier == FormUserUtilitesCompanyItemType.accountNumber.identifier {
            userUtitlitesCompany?.accountNumber = value ?? ""
       }
    }
    
    func changedSelectItem(identifier: String?, by index: Int) {
        if identifier == FormUserUtilitesCompanyItemType.company.identifier
            && listCompanies.count > index {
            userUtitlitesCompany?.company = listCompanies[index]
            checkChangeNeedCompanyCounter()
        }
    }

    private func checkChangeNeedCompanyCounter() {
        guard let company = userUtitlitesCompany?.company else { return }
        let oldValue = isNeedCounter
        let newValue = company.isNeedCounter
        let counterSection = FormUserUtilitesCompanyItemType.counter
        isNeedCounter = newValue
        if oldValue != newValue {
            if newValue {
                formUserCompanyView?.insertSection(counterSection.rawValue)
            } else {
                formUserCompanyView?.removeSection(counterSection.rawValue)
                userUtitlitesCompany?.counters.removeAll()
            }
        }
    }
    
    
    
    // MARK: section configure methods
    func getTypeHeaderView(by section: Int) -> FormSectionHeaderType? {
        return FormSectionHeaderType(rawValue: section)
    }
    
    func configure(view: BasicSectionHeaderVeiwProtocol, for section: Int) {
        switch view {
        case let header as SectionViewHeaderAdd:
            header.displayTitle("Counters")
            header.delegate = formUserCompanyView as? SectionViewHeaderAddDelegate
            header.identifier = FormSectionHeaderType.addViewCounter.identifier
        default: break
        }
    }
    
    // MARK: add new view
    func actionSectionAddView(by identifier: String) {
        switch identifier {
        case FormSectionHeaderType.addViewCounter.identifier:
            showAlertCounter(saveComletionHandler: saveNewCounter)
        default:
            break
        }
    }

    private func saveNewCounter(_ model: AlertFormModel) {
        guard let identifier = model.getFieldValue(by: Counter.CodingKeys.identifier.rawValue),
            let placeInstallation = model.getFieldValue(by: Counter.CodingKeys.placeInstallation.rawValue) else {
                return
        }
        
        let counter = Counter(identifier: identifier, placeInstallation: placeInstallation)
        userUtitlitesCompany?.counters.append(counter)
        let indexPath = IndexPath(row: (userUtitlitesCompany?.counters.count ?? 1) - 1,
                                  section: FormUserUtilitesCompanyItemType.counter.rawValue)
        formUserCompanyView?.insertCell(by: indexPath)
    }
    
    
    // MARK: action
    func actionDeleteItem(by indexPath: IndexPath) {
        guard let type = FormUserUtilitesCompanyItemType(rawValue: indexPath.section) else { return }
        guard var userUtitlitesCompany = self.userUtitlitesCompany else { return }
        
        if type == .counter && userUtitlitesCompany.counters.count > indexPath.row {
            
            func actionDeleteCounter<T>(_ action: T) {
                self.userUtitlitesCompany?.counters.remove(at: indexPath.row)
                self.formUserCompanyView?.removeCell(by: indexPath)
            }
            
            let model = AlertModelView(title: "Are you sure delete counter?", message: nil,
                                       actions: [
                                        AlertActionModelView(title: "Yes",
                                                             action: CommandWith(action: actionDeleteCounter)),
                                        AlertActionModelView(title: "No", action: nil)
                                    ])
            formUserCompanyView?.displayAlert(with: model)
        }
    }
    
    func actionEditItem(by indexPath: IndexPath) {
        
    }
    
    
    // MARK: save methods
    private func checkValidItems() -> Bool {
        var isValid = true
        guard let userUtitlitesCompany = userUtitlitesCompany else { return false }
        
        if userUtitlitesCompany.accountNumber.removeWhiteSpace().isEmpty {
            isValid = false
        }
        
        if userUtitlitesCompany.company == nil {
            isValid = false
        }
        
        return isValid
    }
    
    func saveUserComapany() {
        isNeedValid = true
        if checkValidItems() {
           self.saveInStorageUserComapany()
        } else {
            formUserCompanyView?.displayError("")
            formUserCompanyView?.reloadAllData()
        }
    }
    
    private func saveInStorageUserComapany() {
        guard let userUtitlitesCompany = userUtitlitesCompany else { return }
        userCompanyGateway.save(entity: userUtitlitesCompany) { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success:
                self.formUserCompanyView?.displaySuccessSave()
            case let .failure(error):
                self.formUserCompanyView?.displayError(error.localizedDescription)
            }
        }
    }

    // MARK: show methods
    private func showAlertCounter(by counter: Counter? = nil,
                                  saveComletionHandler: @escaping (AlertFormModel) -> Void) {
        let validText: (String?) -> Bool = { (value) in
            if let value = value, !value.removeWhiteSpace().isEmpty {
                return true
            }
            return false
        }
        let model = AlertFormModel(
            identifier: counter?.identifier ?? "add_counter",
            name: counter == nil ? "Add new counter!" : "Edit counter!",
            fields: [
                AlertFormModel.AlertFormField(
                    identifier: Counter.CodingKeys.identifier.rawValue,
                    name: "Identifier",
                    value: counter?.identifier,
                    checkValid: validText,
                    invaidMessage: "The identifier of counter is empty!"
                ),
                AlertFormModel.AlertFormField(
                    identifier: Counter.CodingKeys.placeInstallation.rawValue,
                    name: "Place installation",
                    value: counter?.placeInstallation,
                    checkValid: validText,
                    invaidMessage: "The place installation of counter is empty!"
                )
            ])
        router.pressentAlertForm(by: model, saveComletionHandler: saveComletionHandler)
    }
}
