//
//  Indicators.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/1/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit.UIColor

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
    
    var color: UIColor {
        switch self {
        case .created: return #colorLiteral(red: 0.968627451, green: 1, blue: 0.968627451, alpha: 1)
        case .sended: return #colorLiteral(red: 0.3058823529, green: 0.8039215686, blue: 0.768627451, alpha: 1)
        case .failed: return #colorLiteral(red: 1, green: 0.4196078431, blue: 0.4196078431, alpha: 1)
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
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    }
}
