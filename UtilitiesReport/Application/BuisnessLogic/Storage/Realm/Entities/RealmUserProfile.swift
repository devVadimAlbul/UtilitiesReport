//
//  RealmUserProfile.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/19/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import UIKit
import RealmSwift

class RealmUserProfile: Object {
    
    @objc dynamic var identifier = UUID().uuidString
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var phoneNumber: String = ""
    @objc dynamic var city: String = ""
    @objc dynamic var street: String = ""
    @objc dynamic var house: String = ""
    @objc dynamic var apartment: String?
    
    override static func primaryKey() -> String? {
        return "identifier"
    }
    
    convenience init(profile: UserProfile) {
        self.init(value: [
            "identifier": profile.identifier,
            "firstName": profile.firstName,
            "lastName": profile.lastName,
            "email": profile.email,
            "phoneNumber": profile.phoneNumber,
            "city": profile.city,
            "house": profile.house,
            "street": profile.street
        ])
        self.apartment = profile.apartment
    }
    
    var userProfileModel: UserProfile {
        return UserProfile(
            identifier: identifier,
            firstName: firstName,
            lastName: lastName,
            email: email,
            phoneNumber: phoneNumber,
            city: city,
            street: street,
            house: house,
            apartment: apartment
        )
    }
}
