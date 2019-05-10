//
//  SelectIndicatorsCountersPresenter.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 4/27/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol SelectIndicatorsCountersPresenter: PresenterProtocol {
    var router: SelectIndicatorsCountersRouter { get set }
    var numberOfSections: Int { get }
    func numberOfRows(in section: Int) -> Int
    func configure(cell: SelectItemCounterViewCell, for indexPath: IndexPath)
    func selectItem(cell: SelectItemCounterViewCell, at index: Int)
    func actionAddNewItem(with cell: SelectItemCounterViewCell)
    func actionSend()
}

class SelectIndicatorsCountersPresenterImpl: SelectIndicatorsCountersPresenter {

    private weak var view: SelectIndicatorsCountersView?
    var router: SelectIndicatorsCountersRouter
    private var selectedIndicator: IndicatorsCounter
    private var userUntilitesCompany: UserUtilitiesCompany
    private var listCounterts: [SelectIndicatorCounterModel] = []
    
    
    init(view: SelectIndicatorsCountersView,
         router: SelectIndicatorsCountersRouter,
         selectedIndicator: IndicatorsCounter,
         userUntilitesCompany: UserUtilitiesCompany) {
        self.view = view
        self.router = router
        self.selectedIndicator = selectedIndicator
        self.userUntilitesCompany = userUntilitesCompany
    }
    
    func viewDidLoad() {
        view?.displayPageTitle("Select indicators")
        view?.displayButtonTitle("Send")
        groupIndicators()
    }
    
    func groupIndicators() {
        listCounterts = userUntilitesCompany.counters.map({ (counter) -> SelectIndicatorCounterModel in
            let list = userUntilitesCompany.indicators.filter({
                $0.counter?.identifier == .some(counter.identifier)
            })
            var selectedIndicator: IndicatorsCounter?
            if self.selectedIndicator.counter?.identifier == .some(counter.identifier) {
                selectedIndicator = self.selectedIndicator
            }
            return SelectIndicatorCounterModel(counter: counter,
                                              selectedIndicator: selectedIndicator,
                                              listIndicators: list, isValid: true)
        })
        view?.updateAllData()
    }
    
    // MARK: config table view
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return listCounterts.count
    }
    
    func configure(cell: SelectItemCounterViewCell, for indexPath: IndexPath) {
        let item = listCounterts[indexPath.row]
        cell.displayTitle(item.counter.placeInstallation)
        cell.displayPlaceholder("Please select indicator")
        cell.displayValue(item.selectedIndicator?.value)
        cell.delegate = view as? SelectItemCounterDelegate
        cell.identifier = item.counter.identifier
        cell.isValid = item.isValid
        cell.isNeedAddItem = true
        
        var selectedIndex: Int?
        if let selectedIndicator = item.selectedIndicator,
            let index = item.listIndicators.firstIndex(where: {$0.identifier == selectedIndicator.identifier}) {
            selectedIndex = index
        }
        let list = item.listIndicators.map({$0.value})
        cell.displayListItems(list, selectedIndex: selectedIndex)
    }
    
    func selectItem(cell: SelectItemCounterViewCell, at index: Int) {
        guard let indexCell = listCounterts.firstIndex(where: {
            $0.counter.identifier == cell.identifier
        }) else { return }
        let item = listCounterts[indexCell].listIndicators[index]
        listCounterts[indexCell].selectedIndicator = item
        listCounterts[indexCell].isValid = true
    }
    
    func actionAddNewItem(with cell: SelectItemCounterViewCell) {
        guard let indexCell = listCounterts.firstIndex(where: {
            $0.counter.identifier == cell.identifier
        }) else { return }
        let counter = listCounterts[indexCell].counter
        view?.displayNewItem(for: counter)
    }
    
    func actionSend() {
        if checkValidItems() {
            let indicators = listCounterts.compactMap({$0.selectedIndicator})
            view?.displaySelected(indicators: indicators)
        } else {
            view?.updateAllData()
            view?.displayError(message: "Not selected indicators for the all counters!")
        }
    }
    
    private func checkValidItems() -> Bool {
        var isValid = true
        for index in 0..<listCounterts.count {
            let isValidItem = listCounterts[index].selectedIndicator != nil
            listCounterts[index].isValid = isValidItem
            if !isValidItem {
                isValid = false
            }
        }
        return isValid
    }
}
