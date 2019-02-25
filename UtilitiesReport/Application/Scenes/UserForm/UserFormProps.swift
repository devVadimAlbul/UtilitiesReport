//
//  UserFormProps.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/20/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit

extension UserFormViewController {
    struct Props: Codable {
        
        enum ItemState {
            case valid
            case invalid(message: String)
        }

        enum PropsState {
            case edit
            case loading
            case falied(error: String)
            case success
        }
        
        struct Item: Codable {
            var name: String
            var value: String?
            var placeholder: String
            var change: CommandWith<String?>
            var state: ItemState
            
            static var initial: Item = Item(name: "", value: nil, placeholder: "", change: .nop, state: .valid)
        }
        
        var firstName: Item
        var lastName: Item
        var phoneNumber: Item
        var email: Item
        var city: Item
        var street: Item
        var house: Item
        var apartment: Item
        var pageTitle: String
        var saveButtonTitle: String
        var state: PropsState
        var actionSave: Command
        
        static var initial: Props = Props(
            firstName: .initial,
            lastName: .initial,
            phoneNumber: .initial,
            email: .initial,
            city: .initial,
            street: .initial,
            house: .initial,
            apartment: .initial,
            pageTitle: "",
            saveButtonTitle: "",
            state: .edit,
            actionSave: .nop
        )
    }   
}

// MARK: - extension ItemState: Codable
extension UserFormViewController.Props.ItemState: Codable {
    enum Keys: CodingKey {
        case type, value
    }
    
    enum Case: String, Codable {
        case valid, invalid
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        switch self {
        case .valid:
            try container.encode(Case.valid, forKey: .type)
        case .invalid(message: let message):
            try container.encode(Case.invalid, forKey: .type)
            try container.encode(message, forKey: .value)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let type = try container.decode(Case.self, forKey: .type)
        
        switch type {
        case .valid: self = .valid
        case .invalid: self = .invalid(message: try container.decode(String.self, forKey: .value))
        }
    }
}

// MARK: - extension PropsState: Codable
extension UserFormViewController.Props.PropsState: Codable {
    enum Keys: CodingKey {
        case type, value
    }
    
    enum Case: String, Codable {
        case edit
        case loading
        case falied
        case success
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        switch self {
        case .edit:
            try container.encode(Case.edit, forKey: .type)
        case .loading:
            try container.encode(Case.loading, forKey: .type)
        case .falied(error: let error):
            try container.encode(Case.falied, forKey: .type)
            try container.encode(error, forKey: .value)
        case .success:
            try container.encode(Case.success, forKey: .type)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let type = try container.decode(Case.self, forKey: .type)
        
        switch type {
        case .edit: self = .edit
        case .loading: self = .loading
        case .falied: self = .falied(error: try container.decode(String.self, forKey: .value))
        case .success: self = .success
        }
    }

}
