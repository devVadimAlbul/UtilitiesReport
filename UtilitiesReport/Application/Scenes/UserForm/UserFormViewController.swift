//
//  UserFormViewController.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/10/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import UIKit

protocol UserFormView: AnyObject {
    var configurator: UserFormConfigurator! { get }
    func displayPageTitle(_ title: String)
}

class UserFormViewController: BasicViewController, UserFormView {
    var configurator: UserFormConfigurator!
    var formPresenter: UserFormPresenter? {
        return presneter as? UserFormPresenter
    }

    override func viewDidLoad() {
        configurator.configure(view: self)
        super.viewDidLoad()
    }
    
    func displayPageTitle(_ title: String) {
        
    }
}
