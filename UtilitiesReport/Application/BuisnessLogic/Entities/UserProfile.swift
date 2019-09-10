//
//  UserProfile.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/9/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit

class UserProfile: Equatable {
    
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
                  firstName: String,
                  lastName: String,
                  email: String,
                  phoneNumber: String,
                  city: String,
                  street: String,
                  house: String,
                  apartment: String?) {
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
    
    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func getAllKeys() -> [PartialKeyPath<UserProfile>] {
        return [
            \UserProfile.firstName,
            \UserProfile.lastName,
            \UserProfile.email,
            \UserProfile.phoneNumber,
            \UserProfile.city,
            \UserProfile.street,
            \UserProfile.house
        ]
    }
    
    var namesPaths: [PartialKeyPath<UserProfile>: String] {
        return [ \UserProfile.firstName: "first name",
                 \UserProfile.lastName: "last name",
                 \UserProfile.email: "email",
                 \UserProfile.phoneNumber: "phone number",
                 \UserProfile.city: "city",
                 \UserProfile.street: "street",
                 \UserProfile.house: "house"]
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
