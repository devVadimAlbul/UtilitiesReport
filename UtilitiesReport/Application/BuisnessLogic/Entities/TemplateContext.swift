//
//  TemplateContext.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/30/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

struct TemplateContext {
    var company: UserUtilitiesCompany
    var user: UserProfile
    var indicators: [IndicatorsCounter]
    
    enum CodingKeys: String, CodingKey {
        case company
        case user
        case indicators
    }
    
    var context: [String: Any] {
        return [
            "company": company.context,
            "user": user.context,
            "indicators": indicators.map({$0.context})
        ]
    }
}
