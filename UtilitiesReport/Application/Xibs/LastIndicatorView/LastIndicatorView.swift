//
//  LastIndicatorView.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/13/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit

protocol LastIndicatorViewProtocol: AnyObject {
    func displayName(_ name: String?)
    func displayMonths(_ months: String?)
    func displayValue(_ value: String?)
}

class LastIndicatorView: ViewFromXib, LastIndicatorViewProtocol {
    
    // MARK: property
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMonths: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    
    // MARK: display methods
    func displayName(_ name: String?) {
        lblName.text = name
        lblName.isHidden = name == nil
    }
    
    func displayMonths(_ months: String?) {
        lblMonths.text = months
    }
    
    func displayValue(_ value: String?) {
        lblValue.text = value
    }
}
