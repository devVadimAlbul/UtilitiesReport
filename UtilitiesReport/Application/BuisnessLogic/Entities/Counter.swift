//
//  Counter.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/26/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation


struct Counter {
    var identifier: String
    var placeInstallation: String
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case placeInstallation = "place_installation"
    }
    
    var context: [String: Any] {
        return [
            "id": identifier,
            "place": placeInstallation
        ]
    }
}
