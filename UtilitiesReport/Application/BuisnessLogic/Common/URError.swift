//
//  URError.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/13/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

enum URError: Error {
    case userNotAuth
    case userNotFound
    case userNotCreated
    case textNotRecognized
    case incorrectProfileForm
    case companyNoSaved
    case companyCantRemoved
    case companyNotFound
    case userCompanyNotFound
    case incorrectUserUtitliesCompany
    case idicatorCounterCantRemoved
    case notAvailable(String)
    case templateNotFound
    case urlInvalid
    case phoneNumberInvalid
    case reportNotSend
    case emailInvalid
    case incorrectSingUpData
}

extension URError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .userNotAuth: return "User Not Authorized!"
        case .userNotFound: return "User not found!"
        case .userNotCreated: return "User not created!\nPlease check input data and try again."
        case .textNotRecognized: return "Text not recognized on this image!"
        case .incorrectProfileForm: return "User Profile data incorrect in form.\nPlease check is it and try again."
        case .incorrectSingUpData: return "Sing up data incorrect in form.\nPlease check is it and try again."
        case .companyNoSaved: return "Company no saved.\nPlease check is it and try again."
        case .companyCantRemoved: return "The company can't be removed.\nPlease check is it and try again."
        case .companyNotFound: return "This company not found.\nPlease try again later."
        case .userCompanyNotFound: return "User untility company not found.\nPlease try again later."
        case .incorrectUserUtitliesCompany:
            return "Utilites company data incorrect in form.\nPlease check is it and try again."
        case .idicatorCounterCantRemoved:
            return "Indicator of counter can not deleted."
        case let .notAvailable(name):
            return String(format: "%@ is not available.", name)
        case .templateNotFound:
            return "Company template for send indicators of counter not found."
        case .urlInvalid:
            return "Your url is invalid for send.\nPlease check is it and try again."
        case .phoneNumberInvalid:
            return "Your phone number is invalid for send.\nPlease check is it and try again."
        case .emailInvalid:
            return "Your email is invalid for send.\nPlease check is it and try again."
        case .reportNotSend:
            return "Can not be sent utilities report on company.\nPlease check is it and try again."
        }
    }
}
