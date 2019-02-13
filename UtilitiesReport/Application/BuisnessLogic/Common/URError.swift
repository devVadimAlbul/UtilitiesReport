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
}

extension URError: LocalizedError {
    
    var localizedDescription: String {
        switch self {
        case .userNotCreated: return "User not ctrated!"
        }
    }
}
