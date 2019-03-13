//
//  Company.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/26/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit.UIImage

enum CompanyType: String {
    case water
    case gas
    case electricity
    case `default`
    
    var image: UIImage {
        switch self {
        case .water: return #imageLiteral(resourceName: "tap")
        case .gas: return #imageLiteral(resourceName: "flame")
        case .electricity: return #imageLiteral(resourceName: "idea")
        default: return #imageLiteral(resourceName: "speedometer")
        }
    }
}

struct Company: Equatable {
    var identifier: String = ""
    var name: String = ""
    var isNeedCounter: Bool = false
    var siteURLString: String?
    var city: String = ""
    var type: CompanyType = .default
    
    init() {
    
    }
    
    init(identifier: String, name: String, isNeedCounter: Bool,
         siteURLString: String?, city: String, type: CompanyType = .default) {
        self.identifier = identifier
        self.name = name
        self.isNeedCounter = isNeedCounter
        self.city = city
        self.siteURLString = siteURLString
        self.type = type
    }
    
    static func == (lhs: Company, rhs: Company) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
