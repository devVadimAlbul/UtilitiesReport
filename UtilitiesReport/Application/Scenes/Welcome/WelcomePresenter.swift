//
//  WelcomePresenter.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/21/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol WelcomePresenter: PresenterProtocol {
    var router: WelcomeViewRouler { get }
}

class WelcomePresenterImpl: WelcomePresenter {
   
    // MARK: property
    fileprivate weak var viewContent: WelcomeView?
    var router: WelcomeViewRouler
    
    // MARK: init
    init(view: WelcomeView, router: WelcomeViewRouler) {
        self.viewContent = view
        self.router = router
    }
    
    func viewDidLoad() {
        
    }
}
