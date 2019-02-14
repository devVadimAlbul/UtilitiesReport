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
    var city: String = ""
    var street: String = ""
    var house: String = ""
    var apartment: String?
    var phoneNumber: String = ""
    
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
    
    required init(firstName: String, lastName: String, city: String, street: String,
                  house: String, apartment: String?, phoneNumber: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.city = city
        self.street = street
        self.house = house
        self.apartment = apartment
        self.phoneNumber = phoneNumber
    }

    init() {

    }
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case city = "city"
        case street = "street"
        case house = "house"
        case apartment = "apartment"
        case phoneNumber = "phone_number"
        
        var title: String {
            switch self {
            case .firstName: return "First Name"
            case .lastName: return "Last Name"
            case .city: return "City"
            case .street: return "Street"
            case .house: return "House"
            case .apartment: return "Apartment"
            case .phoneNumber: return "Phone Number"
            }
        }
        
        var placehold: String? {
            switch self {
            case .firstName: return "Enter first name"
            case .lastName: return "Enter last name"
            case .city: return "Enter city"
            case .street: return "Enter street"
            case .house: return "Enter house"
            case .apartment: return "Enter apartment"
            case .phoneNumber: return "Enter phone number"
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
            case .city: return "Incorrect city"
            case .street: return "Incorrect street"
            case .house: return "Incorrect house"
            case .apartment: return nil
            case .phoneNumber: return "Incorrect phone number"
            }
        }
        
        var keybardType: UIKeyboardType {
            switch self {
            case .phoneNumber: return .phonePad
            default: return .default
            }
        }
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try values.decode(String.self, forKey: .firstName)
        lastName = try values.decode(String.self, forKey: .lastName)
        city = try values.decode(String.self, forKey: .city)
        street = try values.decode(String.self, forKey: .street)
        house = try values.decode(String.self, forKey: .house)
        apartment = try values.decodeIfPresent(String.self, forKey: .apartment)
        phoneNumber = try values.decode(String.self, forKey: .phoneNumber)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(city, forKey: .city)
        try container.encode(street, forKey: .street)
        try container.encode(house, forKey: .house)
        try container.encodeIfPresent(apartment, forKey: .apartment)
        try container.encode(phoneNumber, forKey: .phoneNumber)
    }
    
    func setValue(_ value: String?, forKey key: String) {
        guard let key = CodingKeys(rawValue: key) else { return }
        switch key {
        case .firstName: self.firstName = value ?? ""
        case .lastName: self.lastName = value ?? ""
        case .city: self.city = value ?? ""
        case .street: self.street = value ?? ""
        case .house: self.house = value ?? ""
        case .apartment: self.apartment = value
        case .phoneNumber: self.phoneNumber = value ?? ""
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
        (lhs.apartment == rhs.apartment)
    }
}


// MARK: generate ModelView
extension UserProfile {
    
    func generateFormModelView() -> UserProfileFormModalView {
        let models: [FormItemModelView] = [
            getFormItemModel(type: .firstName, value: self.firstName),
            getFormItemModel(type: .lastName, value: self.lastName),
            getFormItemModel(type: .city, value: self.city),
            getFormItemModel(type: .street, value: self.street),
            getFormItemModel(type: .house, value: self.house),
            getFormItemModel(type: .apartment, value: self.apartment),
            getFormItemModel(type: .phoneNumber, value: self.phoneNumber)
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
