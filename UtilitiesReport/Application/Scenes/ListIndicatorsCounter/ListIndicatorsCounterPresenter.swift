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
    
    init(router: ListIndicatorsCounterRouter,
         view: ListIndicatorsCounterView,
         userCompanyIdentifier: String,
         indicatorsCouterGateway: IndicatorsCouterGateway,
         loadUseCase: LoadUserCompaniesUseCase) {
        self.router = router
        self.view = view
        self.userCompanyIdentifier = userCompanyIdentifier
        self.indicatorsCouterGateway = indicatorsCouterGateway
        self.loadUseCase = loadUseCase
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
            case let .failure(error):
                self.view?.displayError(error.localizedDescription)
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
        view?.displayActionSheet(by: model)
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
        view?.displayActionSheet(by: model)
    }
    
    func actionSaveIndicator(value: String) {
        guard let userCompany = self.userCompany else { return }
        let indicator = IndicatorsCounter(date: Date(), value: value,
                                          counter: selectedCounter, state: .created)
        self.selectedCounter = nil
        router.pushToFomIndicator(with: indicator, to: userCompany)
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
            let item =  listSections[indexPath.section].items[indexPath.row]
            cell.displayDateMonths(item.month)
            cell.displayCounter(item.counter?.placeInstallation)
            cell.displayValue(item.value)
            cell.displayState(item.state.name)
        }
    }
}
