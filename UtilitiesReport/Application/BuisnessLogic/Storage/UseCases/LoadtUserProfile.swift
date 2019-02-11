//
//  GetUserProfile.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/11/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

typealias LoadUserProfileUseCaseCompletionHandler = (_ books: Result<UserProfile?>) -> Void

protocol LoadUserProfileUseCase {
    func load(completionHandler: @escaping LoadUserProfileUseCaseCompletionHandler)
}

class LoadUserProfileUseCaseImpl: LoadUserProfileUseCase {
    
    fileprivate let storage: DefaultsStorage
    fileprivate let storageKey: String = Constants.StoregeKeys.userProfile.rawValue
    
    init(storage: DefaultsStorage) {
        self.storage = storage
    }
    
    func load(completionHandler: @escaping LoadUserProfileUseCaseCompletionHandler) {
        do {
            guard let data = try storage.getData(forKey: storageKey) else {
                completionHandler(.success(nil))
                return
            }
            let jsonDecoder = JSONDecoder()
            let user = try jsonDecoder.decode(UserProfile.self, from: data)
            completionHandler(.success(user))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
