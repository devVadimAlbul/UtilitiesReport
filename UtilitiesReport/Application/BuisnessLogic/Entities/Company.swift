//
//  Company.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/26/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

struct Company: Equatable {
    var identifier: String = ""
    var name: String = ""
    var isNeedCounter: Bool = false
    var siteURLString: String?
    var city: String = ""
    
    init() {
    
    }
    
    init(identifier: String, name: String, isNeedCounter: Bool,
         siteURLString: String?, city: String) {
        self.identifier = identifier
        self.name = name
        self.isNeedCounter = isNeedCounter
        self.city = city
        self.siteURLString = siteURLString
    }
    
    static func == (lhs: Company, rhs: Company) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
