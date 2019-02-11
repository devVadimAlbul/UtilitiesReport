//
//  UserProfileSave.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/11/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

typealias SaveUserProfileUseCaseCompletionHandler = (_ books: Result<Void>) -> Void

protocol SaveUserProfileUseCase {
    func save(user: UserProfile, completionHandler: @escaping SaveUserProfileUseCaseCompletionHandler)
}

class SaveUserProfileUseCaseImpl: SaveUserProfileUseCase {
    
    fileprivate let storage: DefaultsStorage
    fileprivate let storageKey: String = Constants.StoregeKeys.userProfile.rawValue
    
    init(storage: DefaultsStorage) {
        self.storage = storage
    }
    
    func save(user: UserProfile, completionHandler: @escaping SaveUserProfileUseCaseCompletionHandler) {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(user)
            try storage.saveData(jsonData, forKey: storageKey)
            completionHandler(.success(()))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
