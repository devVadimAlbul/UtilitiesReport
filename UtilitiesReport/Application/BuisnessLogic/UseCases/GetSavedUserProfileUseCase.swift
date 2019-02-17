//
//  GetSavingUserProfile.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/13/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol GetSavedUserProfileUseCase {
    func getUserProfile(identifier: String) throws -> UserProfile
}

class GetSavedUserProfileUseCaseImpl: GetSavedUserProfileUseCase {
    
    fileprivate let storage: UserProfileLocalStorageGateway
    
    init(storage: UserProfileLocalStorageGateway) {
        self.storage = storage
    }
    
    func getUserProfile(identifier: String = Constants.StoregeKeys.userProfile) throws -> UserProfile {
        let result = storage.getEntity(by: identifier)
        if let value = try result.dematerialize() {
            return value
        }
        throw URError.userNotCreated
    }
}
