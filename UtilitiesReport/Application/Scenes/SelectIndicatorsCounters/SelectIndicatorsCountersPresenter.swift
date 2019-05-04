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
    func configure(cellView: BasicVeiwCellProtocol, for indexPath: IndexPath)
}

class SelectIndicatorsCountersPresenterImpl: SelectIndicatorsCountersPresenter {
    
    struct SelectIndicatorWithCounter {
        var counter: Counter
        var selectedIndicator: IndicatorsCounter?
        var listIndicators: [IndicatorsCounter]
    }

    private weak var view: SelectIndicatorsCountersView?
    var router: SelectIndicatorsCountersRouter
    private var selectedIndicator: IndicatorsCounter
    private var userUntilitesCompany: UserUtilitiesCompany
    private var listCounterts: [SelectIndicatorWithCounter] = []
    
    
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
        
    }
    
    // MARK: config table view
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return listCounterts.count
    }
    
    func configure(cellView: BasicVeiwCellProtocol, for indexPath: IndexPath) {
        guard let cell = cellView as? SelectItemCounterViewCell else { return }
        let item = listCounterts[indexPath.row]
        cell.displayTitle(item.counter.placeInstallation)
        cell.displayPlaceholder("Please select indicator")
        cell.displayValue(item.selectedIndicator?.value)
        var selectedIndex: Int?
        if let selectedIndicator = item.selectedIndicator, let index = item.listIndicators.firstIndex(where: {$0.identifier == selectedIndicator}) {
            selectedIndex = index
        }
        let list = item.listIndicators.map({$0.value})
        cell.displayListItems(list, selectedIndex: selectedIndex)
    }
}
