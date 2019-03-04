//
//  Indicators.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/1/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

struct IndicatorsCounter {

    var identifier: String
    var date: Date
    var value: String
    
    init(identifier: String = UUID().uuidString,
         date: Date = Date(),
         value: String = "") {
        self.identifier = identifier
        self.date = date
        self.value = value
    }

    var numberValue: Int? {
        return Int(value)
    }
}
