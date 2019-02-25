//
//  URError.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/13/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

enum URError: Error {
    case userNotCreated
    case textNotRecognized
    case incorrectProfileForm
}

extension URError: LocalizedError {
    
    var localizedDescription: String {
        switch self {
        case .userNotCreated: return "User not ctrated!"
        case .textNotRecognized: return "Text not recognized on this image!"
        case .incorrectProfileForm: return "User Profile data incorrect in form.\n Please check is it and try again."
        }
    }
}
