//
//  IndicatorsCounter.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/1/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import RealmSwift

class RealmIndicatorsCounter: Object {
    
    @objc dynamic var identifier = UUID().uuidString
    @objc dynamic var date = Date()
    @objc dynamic var value = ""
    @objc dynamic var counter: RealmCounter?
    @objc dynamic var state: String = ""
    
    fileprivate let owners = LinkingObjects(fromType: RealmUserUtilitiesCompany.self, property: "indicators")
    var parent: RealmUserUtilitiesCompany? {
        return self.owners.first
    }
    
    
    override static func primaryKey() -> String? {
        return "identifier"
    }
    
    convenience init(indicator: IndicatorsCounter) {
        self.init(value: [
            "identifier": indicator.identifier,
            "date": indicator.date,
            "value": indicator.value,
            "state": indicator.state.rawValue
        ])
        if let counter = indicator.counter {
           self.counter = RealmCounter(counter: counter)
        }
    }
    
    var indicatorsModel: IndicatorsCounter {
        return IndicatorsCounter(identifier: identifier,
                                 date: date,
                                 value: value,
                                 counter: counter?.counterModel,
                                 state: IndicatorState(rawValue: state) ?? .created)
    }
}
