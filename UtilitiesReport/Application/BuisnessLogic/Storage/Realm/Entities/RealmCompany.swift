//
//  RealmCompany.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/28/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import RealmSwift



class RealmCompany: Object {
    @objc dynamic var identifier = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var isNeedCounter: Bool = false
    @objc dynamic var siteURLString: String?
    @objc dynamic var city: String = ""
    @objc dynamic var typeValue: String = ""
    
    override static func primaryKey() -> String? {
        return "identifier"
    }
    
    convenience init(company: Company) {
        self.init(value: [
            "identifier": company.identifier,
            "name": company.name,
            "isNeedCounter": company.isNeedCounter,
            "city": company.city,
            "typeValue": company.type.rawValue
        ])
        self.siteURLString = company.siteURLString
    }
    
    var companyModel: Company {
        return Company(
            identifier: identifier,
            name: name,
            isNeedCounter: isNeedCounter,
            siteURLString: siteURLString,
            city: city,
            type: CompanyType(rawValue: typeValue) ?? .default
        )
    }
}
