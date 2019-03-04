//
//  UserUtilitiesXompany.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/26/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit

struct UserUtilitiesCompany {
    
    var accountNumber: String
    var company: Company?
    var counters: [Counter]
    var indicators: [IndicatorsCounter]
    
    init(accountNumber: String = "",
         company: Company? = nil,
         counters: [Counter] = [],
         indicators: [IndicatorsCounter] = []) {
        self.accountNumber = accountNumber
        self.company = company
        self.counters = counters
        self.indicators = indicators
    }
}
