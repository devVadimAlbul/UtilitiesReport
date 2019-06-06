//
//  UserProfileLocalStorageGateway.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/13/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol UserProfileLocalStorageGateway: UserProfileGateway {
}

// sourcery:begin: AutoMockable
extension UserProfileLocalStorageGateway {}
// sourcery:end

class UserProfileLocalStorageGatewayImpl: UserProfileLocalStorageGateway {
    
    fileprivate let storage: RealmManagerProtocol
    
    init(storage: RealmManagerProtocol = RealmManager()) {
        self.storage = storage
    }
    
    
    func loadEntity(completionHandler: @escaping (Result<UserProfile, Error>) -> Void) {
        if let object = storage.allEntities(withType: RealmUserProfile.self).first {
            completionHandler(.success(object.userProfileModel))
        } else {
            completionHandler(.failure(URError.userNotCreated))
        }
    }
    
    func add(parameters: UserProfile, completionHandler: @escaping (Result<UserProfile, Error>) -> Void) {
        do {
            let object = RealmUserProfile(profile: parameters)
            try storage.save(object, update: true) {
                completionHandler(.success(object.userProfileModel))
            }
        } catch {
            completionHandler(.failure(error))
        }
    }
    
    func delete(entity: UserProfile, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        if let object = storage.getEntity(withType: RealmUserProfile.self, for: entity.identifier) {
            do {
                try storage.remove(object, cascading: true)
                completionHandler(.success(()))
            } catch {
                completionHandler(.failure(error))
            }
        } else {
            completionHandler(.success(()))
        }
    }
    
}
