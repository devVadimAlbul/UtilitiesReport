//
//  TemplateReport.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/24/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

enum TemplateType: String {
    case form
    case sms
    case email
    
    var name: String {
        switch self {
        case .form:
            return "From"
        case .sms:
            return "SMS"
        case .email:
            return "Email"
        }
    }
}

struct TemplateReport: Equatable {
    var identifier: String
    var companyID: String
    var company: Company?
    var type: TemplateType
    var sendTo: String
    var templateUrlString: String
    
    var sendToURL: URL? {
        return URL(string: sendTo)
    }
    
    static func == (lhs: TemplateReport, rhs: TemplateReport) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
