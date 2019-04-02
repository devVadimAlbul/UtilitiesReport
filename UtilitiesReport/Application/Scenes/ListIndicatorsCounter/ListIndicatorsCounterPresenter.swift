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
    func actionSaveIndicator(value: String)
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func configure(cell: BasicVeiwCellProtocol, at indexPath: IndexPath)
    func titleForHeader(in section: Int) -> String?
    func actionSendItem(at indexPath: IndexPath)
}

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
    private var downloadGateway: ApiDownloadTemplateGateway
    private var templates: [TemplateReport] = []
    private var generateTemplate: GenerateTemplateUseCase
    
    init(router: ListIndicatorsCounterRouter,
         view: ListIndicatorsCounterView,
         userCompanyIdentifier: String,
         indicatorsCouterGateway: IndicatorsCouterGateway,
         loadUseCase: LoadUserCompaniesUseCase,
         templatesGateway: TemplatesGateway,
         downloadGateway: ApiDownloadTemplateGateway,
         generateTemplate: GenerateTemplateUseCase) {
        
        self.router = router
        self.view = view
        self.userCompanyIdentifier = userCompanyIdentifier
        self.indicatorsCouterGateway = indicatorsCouterGateway
        self.loadUseCase = loadUseCase
        self.templatesGateway = templatesGateway
        self.downloadGateway = downloadGateway
        self.generateTemplate = generateTemplate
    }
    
    // MARK: load content
    func viewDidLoad() {
     
    }
    
    func updateContent() {
        loadContent()
    }
    
    private func loadContent() {
        loadUseCase.loadCompany(by: userCompanyIdentifier) { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case let .success(userCompany):
                self.userCompany = userCompany
                let name = userCompany.company?.name ?? userCompany.accountNumber
                self.view?.displayPageTitle(name)
                self.listSections = self.generateSections(userCompany.indicators)
                self.view?.reloadAllData()
                self.loadTemplates()
            case let .failure(error):
                self.view?.displayError(error.localizedDescription)
            }
        }
    }
    
    private func loadTemplates() {
        guard let userCompany = self.userCompany, let company = userCompany.company else { return }
        templatesGateway.fetch(company: company.identifier) { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case let .success(templates):
                self.templates = templates
            case let .failure(error):
                print("[ListIndicatorsCounter] loadTemplates error:", error)
//                self.view?.displayError(error.localizedDescription)
            }
        }
    }
    
    private func generateSections(_ list: [IndicatorsCounter]) -> [SectionItemsModel<IndicatorsCounter>] {
        let sortedList = list.sorted(by: {$0.date.compare($1.date) == .orderedAscending})
        let group = Dictionary(grouping: sortedList) { $0.month }
        let section = group.map { (key, values) -> SectionItemsModel<IndicatorsCounter> in
            return SectionItemsModel(title: key, items: values)
        }
        let sortSections = section
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
    
    func actionSaveIndicator(value: String) {
        guard let userCompany = self.userCompany else { return }
        let indicator = IndicatorsCounter(date: Date(), value: value,
                                          counter: selectedCounter, state: .created)
        self.selectedCounter = nil
        router.pushToFomIndicator(with: indicator, to: userCompany)
    }
    
    private func selectTepmlates(indicator: IndicatorsCounter) {
        guard !templates.isEmpty else {
            self.view?.displayError(URError.templateNotFound.localizedDescription)
            return
        }
        let actionModels: [AlertActionModelView] = templates.map { (template) in
            return AlertActionModelView(title: template.type.name,
                                        action: CommandWith(action: { [weak self] _ in
                                            self?.sendIndicators(indicator, with: template)
                                        })
            )
        }
        let model = AlertModelView(title: "Send indicator of counter by use:",
                                   message: nil, actions: actionModels)
        router.presentActionSheet(by: model)
    }
    
    private func sendIndicators(_ indicator: IndicatorsCounter, with template: TemplateReport) {
        downloadGateway.download(parameter: template, progressHandler: { (progress) in
            
        }, complationHandler: { [weak self, template, indicator] result in
            guard let `self` = self else { return }
            switch result {
            case let .success(content):
                self.createTemplate([indicator], with: content, to: template)
            case let .failure(error):
                self.view?.displayError(error.localizedDescription)
            }
        })
    }
    
    private func createTemplate(_ indicators: [IndicatorsCounter],
                                with templateContent: String,
                                to template: TemplateReport) {
        guard let userCompany = userCompany else {
            let error = URError.userCompanyNotFound
            view?.displayError(error.localizedDescription)
            return
        }
        generateTemplate.generate(with: indicators, by: userCompany,
                                  template: templateContent) { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case let .success(content):
                print(content)
                
            case let .failure(error):
                self.view?.displayError(error.localizedDescription)
            }
        }
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
    
    func actionSendItem(at indexPath: IndexPath) {
        let item = listSections[indexPath.section].items[indexPath.row]
        selectTepmlates(indicator: item)
    }
}
