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
        if let apartment = self.apartment {
            addr += ", apt: \(apartment)"
        }
        return addr
    }
    
    required init(firstName: String, lastName: String,
                  email: String, phoneNumber: String,
                  city: String, street: String,
                  house: String, apartment: String?)   {
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
        case firstName = "first_name"
        case lastName = "last_name"
        case phoneNumber = "phone_number"
        case email = "email"
        case city = "city"
        case street = "street"
        case house = "house"
        case apartment = "apartment"
        
        var title: String {
            switch self {
            case .firstName: return "First Name"
            case .lastName: return "Last Name"
            case .email: return "Email"
            case .phoneNumber: return "Phone Number"
            case .city: return "City"
            case .street: return "Street"
            case .house: return "House"
            case .apartment: return "Apartment"
            }
        }
        
        var placehold: String? {
            switch self {
            case .firstName: return "Enter first name"
            case .lastName: return "Enter last name"
            case .email: return "Enter Email"
            case .phoneNumber: return "Enter phone number"
            case .city: return "Enter city"
            case .street: return "Enter street"
            case .house: return "Enter house"
            case .apartment: return "Enter apartment"
            }
        }
        
        var isOptional: Bool {
            switch self {
            case .apartment: return true
            default: return false
            }
        }
        
        var warningMessage: String? {
            switch self {
            case .firstName: return "Incorrect first name"
            case .lastName: return "Incorrect last name"
            case .email: return "Incorrect email"
            case .phoneNumber: return "Incorrect phone number"
            case .city: return "Incorrect city"
            case .street: return "Incorrect street"
            case .house: return "Incorrect house"
            case .apartment: return nil
            }
        }
        
        var keybardType: UIKeyboardType {
            switch self {
            case .phoneNumber: return .phonePad
            case .email: return .emailAddress
            default: return .default
            }
        }
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
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
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(email, forKey: .email)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(city, forKey: .city)
        try container.encode(street, forKey: .street)
        try container.encode(house, forKey: .house)
        try container.encodeIfPresent(apartment, forKey: .apartment)
    }
    
    func setValue(_ value: String?, forKey key: String) {
        guard let key = CodingKeys(rawValue: key) else { return }
        switch key {
        case .firstName: self.firstName = value ?? ""
        case .lastName: self.lastName = value ?? ""
        case .email: self.email = value ?? ""
        case .phoneNumber: self.phoneNumber = value ?? ""
        case .city: self.city = value ?? ""
        case .street: self.street = value ?? ""
        case .house: self.house = value ?? ""
        case .apartment: self.apartment = value
        }
    }
    
    func checkValidContent() -> [String] {
        var invalidItems: [String] = []
        if firstName.removeWhiteSpace().isEmpty {
            invalidItems.append(CodingKeys.firstName.rawValue)
        }
        if lastName.removeWhiteSpace().isEmpty {
            invalidItems.append(CodingKeys.lastName.rawValue)
        }
        if email.removeWhiteSpace().isEmpty {
            invalidItems.append(CodingKeys.email.rawValue)
        }
        if city.removeWhiteSpace().isEmpty {
            invalidItems.append(CodingKeys.city.rawValue)
        }
        if street.removeWhiteSpace().isEmpty {
            invalidItems.append(CodingKeys.street.rawValue)
        }
        if house.removeWhiteSpace().isEmpty {
            invalidItems.append(CodingKeys.house.rawValue)
        }
        if phoneNumber.removeWhiteSpace().isEmpty {
            invalidItems.append(CodingKeys.phoneNumber.rawValue)
        }
        return invalidItems
    }
    
    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
        return (lhs.firstName == rhs.firstName) &&
        (lhs.lastName == rhs.lastName) &&
        (lhs.city == rhs.city) &&
        (lhs.house == rhs.house) &&
        (lhs.street == rhs.street) &&
        (lhs.phoneNumber == rhs.phoneNumber) &&
        (lhs.email == rhs.email) &&
        (lhs.apartment == rhs.apartment)
    }
}


// MARK: generate ModelView
extension UserProfile {
    
    func generateFormModelView() -> UserProfileFormModalView {
        let models: [FormItemModelView] = [
            getFormItemModel(type: .firstName, value: self.firstName),
            getFormItemModel(type: .lastName, value: self.lastName),
            getFormItemModel(type: .email, value: self.email),
            getFormItemModel(type: .phoneNumber, value: self.phoneNumber),
            getFormItemModel(type: .city, value: self.city),
            getFormItemModel(type: .street, value: self.street),
            getFormItemModel(type: .house, value: self.house),
            getFormItemModel(type: .apartment, value: self.apartment)
        ]
        return UserProfileFormModalView(items: models)
    }
    
    private func getFormItemModel(type: CodingKeys, value: String?) -> FormItemModelView {
        return FormItemModelView(
            identifier: type.rawValue,
            title: type.title,
            placeholder: type.placehold,
            value: value,
            warningMessage: type.warningMessage,
            isOptional: type.isOptional,
            keyboardType: type.keybardType
        )
    }
}
