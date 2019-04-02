//
//  ApiTemplateReport.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/24/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

struct ApiTemplateReport: Decodable, Equatable {
    
    var identifier: String
    var companyID: String
    var type: String
    var sendTo: String
    var templateUrlString: String
    var company: ApiCompany?
    
    static func == (lhs: ApiTemplateReport, rhs: ApiTemplateReport) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case companyID = "companyId"
        case sendTo = "send_to"
        case type = "type"
        case templateUrlString = "template"
        case company = "company"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try values.decode(String.self, forKey: .identifier)
        companyID = try values.decode(String.self, forKey: .companyID)
        sendTo = try values.decode(String.self, forKey: .sendTo)
        templateUrlString = try values.decode(String.self, forKey: .templateUrlString)
        type = try values.decode(String.self, forKey: .type)
        company = try values.decodeIfPresent(ApiCompany.self, forKey: .company)
    }
    
    var entity: TemplateReport {
        return TemplateReport(
            identifier: identifier,
            companyID: companyID,
            company: company?.entity,
            type: TemplateType(rawValue: type) ?? .form,
            sendTo: sendTo,
            templateUrlString: templateUrlString
        )
    }
}
