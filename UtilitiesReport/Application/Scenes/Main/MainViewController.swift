//
//  MainViewController.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/9/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import UIKit

protocol MainView: AnyObject {
    
}

class MainViewController: BasicViewController, MainView {
    
    var configurator: MainConfigurator!
    var mainPresenter: MainPresenter? {
        return presneter as? MainPresenter
    }

    override func viewDidLoad() {
        configurator = MainConfiguratorImpl()
        configurator.configure(viewController: self)
        super.viewDidLoad()
    }

}
