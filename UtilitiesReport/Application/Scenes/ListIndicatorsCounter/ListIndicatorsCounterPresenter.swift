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
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func configure(cell: BasicVeiwCellProtocol, at indexPath: IndexPath)
}

class ListIndicatorsCounterPresenterImpl: ListIndicatorsCounterPresenter {
    
    var router: ListIndicatorsCounterRouter
    private weak var view: ListIndicatorsCounterView?
    private var indicatorsCouterGateway: IndicatorsCouterGateway
    private var findUseCase: FindIndicatorsCounterUseCase
    private var userCompanyIdentifier: String
    private var listSections: [SectionItemsModel<IndicatorsCounter>] = []
    
    init(router: ListIndicatorsCounterRouter,
         view: ListIndicatorsCounterView,
         userCompanyIdentifier: String,
         indicatorsCouterGateway: IndicatorsCouterGateway,
         findUseCase: FindIndicatorsCounterUseCase) {
        self.router = router
        self.view = view
        self.userCompanyIdentifier = userCompanyIdentifier
        self.indicatorsCouterGateway = indicatorsCouterGateway
        self.findUseCase = findUseCase
    }
    
    // MARK: load content
    func viewDidLoad() {
        loadContent()
    }
    
    private func loadContent() {
        findUseCase.findListIndiactors(companyId: userCompanyIdentifier) { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case let .success(name, list):
                self.view?.displayPageTitle(name)
                self.listSections = self.generateSections(list)
                self.view?.reloadAllData()
            case let .failure(error):
                self.view?.displayError(error.localizedDescription)
            }
        }
    }
    
    private func generateSections(_ list: [IndicatorsCounter]) -> [SectionItemsModel<IndicatorsCounter>] {
        let group = Dictionary(grouping: list) { $0.month }
        let section = group.map { (key, values) -> SectionItemsModel<IndicatorsCounter> in
            return SectionItemsModel(title: key, items: values)
        }
        
        let sortSections = section.sorted(by: {
            $0.items.first!.date.compare($1.items.first!.date) == .orderedDescending
        })
        return sortSections
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
