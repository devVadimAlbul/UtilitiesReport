//
//  UserProfileSave.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/11/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

typealias SaveUserProfileUseCaseCompletionHandler = (_ books: Result<Void, Error>) -> Void

protocol SaveUserProfileUseCase {
    func save(user: UserProfile, completionHandler: @escaping SaveUserProfileUseCaseCompletionHandler)
}

class SaveUserProfileUseCaseImpl: SaveUserProfileUseCase {
    
    fileprivate let storage: UserProfileLocalStorageGateway
    
    init(storage: UserProfileLocalStorageGateway) {
        self.storage = storage
    }
    
    func save(user: UserProfile, completionHandler: @escaping SaveUserProfileUseCaseCompletionHandler) {
        storage.add(parameters: user) { (result) in
            switch result {
            case .success: completionHandler(.success(()))
            case .failure(let error): completionHandler(.failure(error))
            }
        }
    }
}
