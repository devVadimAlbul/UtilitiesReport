//
//  BasicViewController.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/9/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import UIKit

class BasicViewController: UIViewController {
    
    var presneter: PresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        presneter?.viewDidLoad()
    }
}
