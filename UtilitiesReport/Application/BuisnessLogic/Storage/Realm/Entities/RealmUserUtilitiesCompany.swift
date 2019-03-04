//
//  RealmUserUtilitiesCompany.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/1/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import RealmSwift

class RealmUserUtilitiesCompany: Object {
    
    @objc dynamic var accountNumber = ""
    @objc dynamic var company: RealmCompany?
    let counters = List<RealmCounter>()
    var indicators = List<RealmIndicatorsCounter>()
    
    override static func primaryKey() -> String? {
        return "accountNumber"
    }
    
    convenience init(userCompany: UserUtilitiesCompany) {
        self.init(value: [
                "accountNumber": userCompany.accountNumber
            ])
        if let company = userCompany.company {
            self.company = RealmCompany(company: company)
        }
        let counters = userCompany.counters.map({RealmCounter(counter: $0)})
        self.counters.append(objectsIn: counters)
        let indicators = userCompany.indicators.map({RealmIndicatorsCounter(indicator: $0)})
        self.indicators.append(objectsIn: indicators)
    }
    
    var objectCopy: RealmUserUtilitiesCompany {
        return RealmUserUtilitiesCompany(value: self)
    }
    
    var userCompanyModel: UserUtilitiesCompany {
        return UserUtilitiesCompany(
            accountNumber: accountNumber,
            company: company?.companyModel,
            counters: counters.map({$0.counterModel}),
            indicators: indicators.map({$0.indicatorsModel}))
    }
}
