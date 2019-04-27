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

    private weak var view: SelectIndicatorsCountersView?
    var router: SelectIndicatorsCountersRouter
    
    init(view: SelectIndicatorsCountersView,
         router: SelectIndicatorsCountersRouter) {
        self.view = view
        self.router = router
    }
    
    func viewDidLoad() {
        
    }
    
    // MARK: config table view
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return 0
    }
    
    func configure(cellView: BasicVeiwCellProtocol, for indexPath: IndexPath) {
        
    }
}
