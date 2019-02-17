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
    
    fileprivate let storage: UserProfileLocalStorageGateway
    
    init(storage: UserProfileLocalStorageGateway) {
        self.storage = storage
    }
    
    func load(completionHandler: @escaping LoadUserProfileUseCaseCompletionHandler) {
        storage.fetchBooks { result in
            switch result {
            case .success(let users): completionHandler(.success(users.first))
            case .failure(let error): completionHandler(.failure(error))
            }
        }
    }
}
