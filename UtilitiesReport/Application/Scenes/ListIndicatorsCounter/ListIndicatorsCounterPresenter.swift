//
//  File.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/14/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol ListIndicatorsCounterPresenter: PresenterProtocol {
    var router: ListIndicatorsCounterRouter { get set }
    func updateContent()
    func actionAddNewIndicator()
    func actionAddNewIndicator(with counter: Counter)
    func actionSaveIndicator(value: String)
    func actionSendIndicators(with list: [IndicatorsCounter])
    func checkIsEmptyList() -> Bool
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func configure(cell: BasicVeiwCellProtocol, at indexPath: IndexPath)
    func titleForHeader(in section: Int) -> String?
    func canEditCell(at indexPath: IndexPath) -> Bool
    func actionDeleteIndicator(for indexPath: IndexPath)
    func actionSendItem(at indexPath: IndexPath)
}

// swiftlint:disable type_body_length
class ListIndicatorsCounterPresenterImpl: ListIndicatorsCounterPresenter {
    
    var router: ListIndicatorsCounterRouter
    private weak var view: ListIndicatorsCounterView?
    private var indicatorsCouterGateway: IndicatorsCouterGateway
    private var loadUseCase: LoadUserCompaniesUseCase
    private var userCompanyIdentifier: String
    private var userCompany: UserUtilitiesCompany?
    private var selectedCounter: Counter?
    private var listSections: [SectionItemsModel<IndicatorsCounter>] = []
    private var templatesGateway: TemplatesGateway
    private var formationReportManager: FormationReportManager
    private var templates: [TemplateReport] = []
    private var isNeedUpdate: Bool = false
    private var isTemplatesLoaded: Bool = false
    private var commandTemplatesLoad: Command?
    
    init(router: ListIndicatorsCounterRouter,
         view: ListIndicatorsCounterView,
         userCompanyIdentifier: String,
         indicatorsCouterGateway: IndicatorsCouterGateway,
         loadUseCase: LoadUserCompaniesUseCase,
         templatesGateway: TemplatesGateway,
         formationReportManager: FormationReportManager) {
        
        self.router = router
        self.view = view
        self.userCompanyIdentifier = userCompanyIdentifier
        self.indicatorsCouterGateway = indicatorsCouterGateway
        self.loadUseCase = loadUseCase
        self.templatesGateway = templatesGateway
        self.formationReportManager = formationReportManager
    }
    
    // MARK: load content
    func viewDidLoad() {
        isNeedUpdate = true
        let text = "List indicators of counter is empty!\nPlease add indicators, clicking to button \"+\"."
        view?.displayEmptyMessage(text)
    }
    
    func updateContent() {
        loadContent { [weak self] isSuccess in
            guard let `self` = self else { return }
            if self.isNeedUpdate {
                if self.listSections.isEmpty {
                    self.actionAddNewIndicator()
                }
            }
            self.isNeedUpdate = false
            
            if isSuccess {
                self.isTemplatesLoaded = false
                self.loadTemplates()
            }
            
        }
    }
    
    private func loadContent(completion: ((Bool) -> Void)? = nil) {
        loadUseCase.loadCompany(by: userCompanyIdentifier) { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case let .success(userCompany):
                self.userCompany = userCompany
                let name = userCompany.company?.name ?? userCompany.accountNumber
                self.view?.displayPageTitle(name)
                self.listSections = self.generateSections(userCompany.indicators)
                self.view?.reloadAllData()
                completion?(true)
            case let .failure(error):
                self.view?.displayError(error.localizedDescription)
                completion?(false)
            }
        }
    }
    
    private func loadTemplates() {
        guard let userCompany = self.userCompany, let company = userCompany.company else {
            self.isTemplatesLoaded = true
            self.commandTemplatesLoad?.perform()
            return
        }
        templatesGateway.fetch(company: company.identifier) { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case let .success(templates):
                self.templates = templates
            case let .failure(error):
                print("[ListIndicatorsCounter] loadTemplates error:", error)
//                self.view?.displayError(error.localizedDescription)
            }
            self.isTemplatesLoaded = true
            self.commandTemplatesLoad?.perform()
        }
    }
    
    private func generateSections(_ list: [IndicatorsCounter]) -> [SectionItemsModel<IndicatorsCounter>] {
        let group = Dictionary(grouping: list) { $0.month }
        let section = group.map { (key, values) -> SectionItemsModel<IndicatorsCounter> in
            let firstDate = values.first?.date ?? Date()
            let items = values.sorted(by: {$0.date.compare($1.date) == .orderedDescending})
            return SectionItemsModel(title: key, items: items, date: firstDate)
        }
        let sortSections = section.sorted(by: {$0.date.compare($1.date) == .orderedDescending})
        return sortSections
    }
    
    // MARK: action Methods
    func actionAddNewIndicator() {
        guard let userCompany = self.userCompany else { return }
        let isNeedCounter = userCompany.company?.isNeedCounter ?? false
        if isNeedCounter {
            if userCompany.counters.count < 2 {
                selectPhotoProvider(counter: userCompany.counters.first)
            } else {
                selectCounters(counters: userCompany.counters)
            }
        } else {
            selectPhotoProvider()
        }
    }
    
    func actionAddNewIndicator(with counter: Counter) {
        selectPhotoProvider(counter: counter)
    }
    
    func actionSaveIndicator(value: String) {
        guard let userCompany = self.userCompany else { return }
        let indicator = IndicatorsCounter(date: Date(), value: value,
                                          counter: selectedCounter, state: .created)
        self.selectedCounter = nil
        router.pushToFormIndicator(with: indicator, to: userCompany)
    }
    
    func actionSendIndicators(with list: [IndicatorsCounter]) {
        selectTepmlates(indicators: list)
    }
    
    // MARK: select methods
    private func selectCounters(counters: [Counter]) {
        func actionModel(_ counter: Counter) -> AlertActionModelView {
            return AlertActionModelView(title: counter.placeInstallation,
                                        action: CommandWith(action: { [weak self, counter] _ in
                self?.selectPhotoProvider(counter: counter)
            }))
        }
        
        let actionItems = counters.map(actionModel)
        let model = AlertModelView(title: "Use counter:",
                                   message: nil, actions: actionItems)
        router.presentActionSheet(by: model)
    }
    
    private func selectPhotoProvider(counter: Counter? = nil) {
        self.selectedCounter = counter
        var actionItems: [AlertActionModelView] = []
        let cameraAction = AlertActionModelView(title: "Camera", action: CommandWith(action: { _ in
            self.view?.displayImagePicker(sourceType: .camera)
        }))
        actionItems.append(cameraAction)
        let libraryAction = AlertActionModelView(title: "Photo library", action: CommandWith(action: { _ in
            self.view?.displayImagePicker(sourceType: .photoLibrary)
        }))
        actionItems.append(libraryAction)
        let model = AlertModelView(title: "Use photos provider:",
                                   message: nil, actions: actionItems)
        
        router.presentActionSheet(by: model)
    }
    
    private func selectTepmlates(indicators: [IndicatorsCounter]) {
        
        func presentListTemplates() {
            if templates.isEmpty {
                self.view?.displayError(URError.templateNotFound.localizedDescription)
            } else {
                let actionModels: [AlertActionModelView] = templates.map { (template) in
                    return AlertActionModelView(title: template.type.name,
                                                action: CommandWith(action: { [weak self] _ in
                                                    self?.formationTemplate(with: indicators, template: template)
                                                })
                    )
                }
                let model = AlertModelView(title: "Send indicator of counter by use:",
                                           message: nil, actions: actionModels)
                router.presentActionSheet(by: model)
            }
        }
        
        if isTemplatesLoaded {
            presentListTemplates()
        } else {
            commandTemplatesLoad = Command(action: {
                presentListTemplates()
                self.commandTemplatesLoad = nil
            })
        }
    }
    
    private func formationTemplate(with indicators: [IndicatorsCounter], template: TemplateReport) {
        guard let userCompany = self.userCompany else { return }
        view?.displayProgress()
        formationReportManager.formation(with: indicators, template: template,
                                         userCompany: userCompany) { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case let .success(model):
                self.send(model: model)
            case let .failure(error):
                self.view?.displayError(error.localizedDescription)
            }
        }
    }
    
    private func send(model: SendReportModel) {
        router.sendReport(model: model) { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case let .success(status):
                switch status {
                case .sent:
                    self.updateState(by: model.indicators, state: .sended)
                    self.view?.displayMessage("Success send utilites report!")
                case .cancelled:
                    self.view?.reloadAllData()
                }
            case let .failure(error):
                self.view?.displayError(error.localizedDescription)
                self.updateState(by: model.indicators, state: .failed)
            }
        }
    }
    
    private func updateState(by indicators: [IndicatorsCounter], state: IndicatorState) {
        var indicators = indicators
        for index in 0..<indicators.count {
            indicators[index].state = state
        }
        indicatorsCouterGateway.save(entities: indicators) { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success:
                self.updateList()
            case let .failure(error):
                self.view?.displayError(error.localizedDescription)
            }
            
        }
    }
    
    private func updateList() {
        loadUseCase.loadCompany(by: userCompanyIdentifier) { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case let .success(userCompany):
                self.userCompany = userCompany
                let name = userCompany.company?.name ?? userCompany.accountNumber
                self.view?.displayPageTitle(name)
                self.listSections = self.generateSections(userCompany.indicators)
                self.view?.reloadAllData()
            case let .failure(error):
                self.view?.displayError(error.localizedDescription)
            }
        }
    }
    
    func checkIsEmptyList() -> Bool {
        return listSections.isEmpty
    }
    
    // MARK: table methods
    func numberOfSections() -> Int {
        return listSections.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return listSections[section].items.count
    }
    
    func configure(cell: BasicVeiwCellProtocol, at indexPath: IndexPath) {
        if let cell = cell as? ItemIndicatorCounterViewCell {
            let item = listSections[indexPath.section].items[indexPath.row]
            cell.delegate = view as? ItemIndicatorCounterCellDelegate
            cell.displayDateMonths(item.month)
            cell.displayCounter(item.counter?.placeInstallation)
            cell.displayValue(item.value)
            cell.displayState(item.state.name, color: item.state.color)
            cell.displayButtonSend(title: "Send", isHidden: item.state == .sended)
        }
    }
    
    func titleForHeader(in section: Int) -> String? {
        let item = listSections[section]
        return item.title
    }
    
    func canEditCell(at indexPath: IndexPath) -> Bool {
        let item = listSections[indexPath.section].items[indexPath.row]
        return item.state != .sended
    }
    
    func actionDeleteIndicator(for indexPath: IndexPath) {
        let item = listSections[indexPath.section].items[indexPath.row]
        indicatorsCouterGateway.delete(entity: item) { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success:
                self.listSections[indexPath.section].items.remove(at: indexPath.row)
                self.view?.removeCell(by: indexPath)
                if self.listSections[indexPath.section].items.isEmpty {
                    self.listSections.remove(at: indexPath.section)
                    self.view?.reloadAllData()
                }
            case let .failure(error):
                self.view?.displayError(error.localizedDescription)
            }
        }
    }
    
    func actionSendItem(at indexPath: IndexPath) {
        let item = listSections[indexPath.section].items[indexPath.row]
        if let userCompany = self.userCompany, userCompany.counters.count >= 2 {
            router.presentSelectIndicatorsCounters(userCompany: userCompany, seletedIndicator: item)
        } else {
            selectTepmlates(indicators: [item])
        }
    }
}
