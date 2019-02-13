//
//  GetSavingUserProfile.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/13/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol GetSavedUserProfileUseCase {
    func getUserProfile() throws -> UserProfile
}

class GetSavedUserProfileUseCaseImpl: GetSavedUserProfileUseCase {
    
    fileprivate let storage: DefaultsStorage
    fileprivate let storageKey = Constants.StoregeKeys.userProfile
    
    init(storage: DefaultsStorage) {
        self.storage = storage
    }
    
    func getUserProfile() throws -> UserProfile {
        guard let data = try storage.getData(forKey: storageKey) else {
            throw URError.userNotCreated
        }
        let jsonDecoder = JSONDecoder()
        let user = try jsonDecoder.decode(UserProfile.self, from: data)
        return user
    }
}
