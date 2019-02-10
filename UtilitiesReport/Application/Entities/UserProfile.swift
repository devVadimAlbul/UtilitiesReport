//
//  UserProfile.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/9/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

struct UserProfile: Codable {
    
    var firstName: String = ""
    var lastName: String = ""
    var numberAcount: String = ""
    var city: String = ""
    var street: String = ""
    var house: String = ""
    var flat: String?
    var phoneNumber: String = ""

    init() {

    }
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case numberAcount = "number_acount"
        case city = "city"
        case street = "street"
        case house = "house"
        case flat = "flat"
        case phoneNumber = "phone_number"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try values.decode(String.self, forKey: .firstName)
        lastName = try values.decode(String.self, forKey: .lastName)
        numberAcount = try values.decode(String.self, forKey: .numberAcount)
        city = try values.decode(String.self, forKey: .city)
        street = try values.decode(String.self, forKey: .street)
        house = try values.decode(String.self, forKey: .house)
        flat = try values.decodeIfPresent(String.self, forKey: .flat)
        phoneNumber = try values.decode(String.self, forKey: .phoneNumber)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(numberAcount, forKey: .numberAcount)
        try container.encode(city, forKey: .city)
        try container.encode(street, forKey: .street)
        try container.encode(house, forKey: .house)
        try container.encode(flat, forKey: .flat)
        try container.encode(phoneNumber, forKey: .phoneNumber)
    }
}
