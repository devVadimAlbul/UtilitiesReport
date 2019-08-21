//
//  WelcomeViewController.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/21/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import UIKit

protocol WelcomeView: AnyObject {
    
}

class WelcomeViewController: BasicViewController, WelcomeView {

    // MARK: IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnStart: ButtonRound!
    @IBOutlet weak var lblDescription: UILabel!
    
    // MARK: property
    var configurator: WelcomeConfigurator!
    var welcomePresenter: WelcomePresenter? {
        return presenter as? WelcomePresenter
    }
    
    // MARK: life-cycle
    override func viewDidLoad() {
        configurator.configure(viewController: self)
        super.viewDidLoad()
//        FirebaseHelper.shared.auth(email: "test.acount.app@gmail.com", password: "acount241")
    }

    // MARK: IBAction
    @IBAction func clickedStart(_ sender: UIButton) {
        welcomePresenter?.router.presentUserForm()
    }
}
