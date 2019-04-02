//
//  Company.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/26/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

struct ApiCompany: Codable, Equatable {
    
    var identifier: String
    var name: String
    var isNeedCounter: Bool = false
    var siteURL: String?
    var city: String
    var type: String
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name = "name"
        case isNeedCounter = "is_need_counter"
        case siteURL = "site_url"
        case city = "city"
        case type = "type"
    }
    
    static func == (lhs: ApiCompany, rhs: ApiCompany) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try values.decode(String.self, forKey: .identifier)
        name = try values.decode(String.self, forKey: .name)
        isNeedCounter = try values.decode(Bool.self, forKey: .isNeedCounter)
        siteURL = try values.decodeIfPresent(String.self, forKey: .siteURL)
        city = try values.decode(String.self, forKey: .city)
        type = try values.decode(String.self, forKey: .type)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(name, forKey: .name)
        try container.encode(isNeedCounter, forKey: .isNeedCounter)
        try container.encode(siteURL, forKey: .siteURL)
        try container.encode(city, forKey: .city)
        try container.encode(type, forKey: .type)
    }

    var entity: Company {
        return Company(
            identifier: identifier,
            name: name,
            isNeedCounter: isNeedCounter,
            siteURLString: siteURL,
            city: city,
            type: CompanyType(rawValue: type) ?? .default
        )
    }
}
