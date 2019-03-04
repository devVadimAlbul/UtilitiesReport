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
    var userUtitlitesCompany: UserUtilitiesCompany? { get set }
    var numberOfSections: Int { get }
    func numberOfRows(in section: Int) -> Int
    func configure(cellView: BasicVeiwCellProtocol, for indexPath: IndexPath)
}

class FormUserUtilitesCompanyPresenterImpl: FormUserUtilitesCompanyPresenter {
    
    private weak var formUserCompanyView: FormUserUtilitesCompanyView?
    var router: FormUserUtilitesCompanyRouter
    var userUtitlitesCompany: UserUtilitiesCompany?
    
    init(view: FormUserUtilitesCompanyView,
         router: FormUserUtilitesCompanyRouter) {
        self.formUserCompanyView = view
        self.router = router
    }
    
    func viewDidLoad() {
        
    }
    
    
    // MARK: table view content
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return 0
    }
    
    
    func configure(cellView: BasicVeiwCellProtocol, for indexPath: IndexPath) {
        
    }
}
