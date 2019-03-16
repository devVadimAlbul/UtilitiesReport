//
//  Indicators.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/1/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

enum IndicatorState: String {
    case created
    case sended
    case failed
    
    var name: String {
        switch self {
        case .created: return "Created"
        case .sended: return "Sended"
        case .failed: return "Failed send"
        }
    }
}

struct IndicatorsCounter {

    var identifier: String
    var date: Date
    var value: String
    var counter: Counter?
    var state: IndicatorState = .created
    
    init(identifier: String = UUID().uuidString,
         date: Date = Date(),
         value: String = "",
         counter: Counter? = nil,
         state: IndicatorState = .created) {
        self.identifier = identifier
        self.date = date
        self.value = value
        self.counter = counter
        self.state = state
    }

    var numberValue: Int? {
        return Int(value)
    }
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: date)
    }
}
