//
//  RealmCounter.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/1/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import RealmSwift

class RealmCounter: Object {
    @objc dynamic var identifier = UUID().uuidString
    @objc dynamic var placeInstallation: String = ""
    
    override static func primaryKey() -> String? {
        return "identifier"
    }
    
    convenience init(counter: Counter) {
        self.init(value: [
            "identifier": counter.identifier,
            "placeInstallation": counter.placeInstallation
        ])
    }

    var counterModel: Counter {
        return Counter(
            identifier: identifier,
            placeInstallation: placeInstallation
         )
    }
}
