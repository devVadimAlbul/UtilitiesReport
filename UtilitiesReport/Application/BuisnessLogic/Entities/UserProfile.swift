//
//  UserProfile.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/9/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit

class UserProfile: Codable, Equatable {
    
    var identifier: String = UUID().uuidString
    var firstName: String = ""
    var lastName: String = ""
    var phoneNumber: String = ""
    var email: String = ""
    var city: String = ""
    var street: String = ""
    var house: String = ""
    var apartment: String?

    
    var name: String {
        return "\(firstName) \(lastName)"
    }
    
    var address: String {
        var addr = "\(city.capitalized), \(street.capitalized) str. \(house)"
        if let apartment = self.apartment, !apartment.removeWhiteSpace().isEmpty {
            addr += ", apt: \(apartment)"
        }
        return addr
    }
    
    required init(identifier: String = UUID().uuidString,
                  firstName: String, lastName: String,
                  email: String, phoneNumber: String,
                  city: String, street: String,
                  house: String, apartment: String?) {
        self.identifier = identifier
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.email = email
        self.city = city
        self.street = street
        self.house = house
        self.apartment = apartment
    }

    init() {

    }
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case phoneNumber = "phone_number"
        case email = "email"
        case city = "city"
        case street = "street"
        case house = "house"
        case apartment = "apartment"
    }
    
    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try values.decode(String.self, forKey: .identifier)
        firstName = try values.decode(String.self, forKey: .firstName)
        lastName = try values.decode(String.self, forKey: .lastName)
        phoneNumber = try values.decode(String.self, forKey: .phoneNumber)
        email = try values.decode(String.self, forKey: .email)
        city = try values.decode(String.self, forKey: .city)
        street = try values.decode(String.self, forKey: .street)
        house = try values.decode(String.self, forKey: .house)
        apartment = try values.decodeIfPresent(String.self, forKey: .apartment)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(email, forKey: .email)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(city, forKey: .city)
        try container.encode(street, forKey: .street)
        try container.encode(house, forKey: .house)
        try container.encodeIfPresent(apartment, forKey: .apartment)
    }
    
    var context: [String: Any] {
        var ctx: [String: Any] = [
            "name": name,
            "phoneNumber": phoneNumber,
            "email": email,
            "city": city,
            "street": street,
            "house": house
        ]
        
        if let apt = apartment {
            ctx["apartment"] = apt
        }
        return ctx
    }
}
