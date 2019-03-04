//
//  GetUserProfile.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/11/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

typealias LoadUserProfileUseCaseCompletionHandler = (_ books: Result<UserProfile>) -> Void

protocol LoadUserProfileUseCase {
    func load(completionHandler: @escaping LoadUserProfileUseCaseCompletionHandler)
}

class LoadUserProfileUseCaseImpl: LoadUserProfileUseCase {
    
    fileprivate let storage: UserProfileLocalStorageGateway
    
    init(storage: UserProfileLocalStorageGateway) {
        self.storage = storage
    }
    
    func load(completionHandler: @escaping LoadUserProfileUseCaseCompletionHandler) {
        storage.fetch { result in
            switch result {
            case .success(let users):
                if let user = users.first {
                    completionHandler(.success(user))
                } else {
                    completionHandler(.failure(URError.userNotCreated))
                }
            case .failure(let error): completionHandler(.failure(error))
            }
        }
    }
}
