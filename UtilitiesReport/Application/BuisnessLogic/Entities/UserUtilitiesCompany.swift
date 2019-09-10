//
//  UserUtilitiesXompany.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/26/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit

struct UserUtilitiesCompany {
    
    var accountNumber: String
    var company: Company?
    var counters: [Counter]
    var indicators: [IndicatorsCounter]
    
    init(accountNumber: String = "",
         company: Company? = nil,
         counters: [Counter] = [],
         indicators: [IndicatorsCounter] = []) {
        self.accountNumber = accountNumber
        self.company = company
        self.counters = counters
        self.indicators = indicators
    }
    
    var context: [String: Any] {
        var ctx: [String: Any] = ["accountNumber": accountNumber]
        
        if let company = self.company {
           ctx["company"] = company.context
        }
        return ctx
    }
  
  static var testItems: [UserUtilitiesCompany] {
    return [
      UserUtilitiesCompany(accountNumber: "12",
                           company: Company(identifier: "1", name: "test1", isNeedCounter: false, siteURLString: nil, city: "Чекраси", type: .water),
                           counters: [],
                           indicators: []),
      UserUtilitiesCompany(accountNumber: "13",
                           company: Company(identifier: "2", name: "test2", isNeedCounter: false, siteURLString: nil, city: "Чекраси", type: .gas),
                           counters: [],
                           indicators: []),
      UserUtilitiesCompany(accountNumber: "14",
                           company: Company(identifier: "3", name: "test3", isNeedCounter: false, siteURLString: nil, city: "Чекраси", type: .electricity),
                           counters: [],
                           indicators: []),
      UserUtilitiesCompany(accountNumber: "15",
                           company: Company(identifier: "4", name: "test4", isNeedCounter: false, siteURLString: nil, city: "Чекраси", type: .default),
                           counters: [],
                           indicators: []),
      UserUtilitiesCompany(accountNumber: "16",
                           company: Company(identifier: "5", name: "test5", isNeedCounter: false, siteURLString: nil, city: "Чекраси", type: .water),
                           counters: [],
                           indicators: []),
      UserUtilitiesCompany(accountNumber: "17",
                           company: Company(identifier: "6", name: "test6", isNeedCounter: false, siteURLString: nil, city: "Чекраси", type: .electricity),
                           counters: [],
                           indicators: []),
    ]
  }
}
