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
    
    fileprivate let storage: StorageProvidable
    let storageKey: String
    
    init(storageKey: String = Constants.StoregeKeys.userProfile,
         storage: StorageProvidable = DefaultsStorageImpl()) {
        self.storageKey = storageKey
        self.storage = storage
    }
    
    func getEntity(by identifier: String) -> Result<UserProfile?> {
        do {
            guard let data = try storage.getData(forKey: identifier) else {
                return .success(nil)
            }
            let jsonDecoder = JSONDecoder()
            let user = try jsonDecoder.decode(UserProfile.self, from: data)
            return .success(user)
        } catch {
            return .failure(error)
        }
    }
    
    func fetch(completionHandler: @escaping (Result<[UserProfile]>) -> Void) {
        do {
            guard let data = try storage.getData(forKey: storageKey) else {
                completionHandler(.success([]))
                return
            }
            let jsonDecoder = JSONDecoder()
            let user = try jsonDecoder.decode(UserProfile.self, from: data)
            completionHandler(.success([user]))
        } catch {
            completionHandler(.failure(error))
        }
    }
    
    func add(parameters: UserProfile, completionHandler: @escaping (Result<UserProfile>) -> Void) {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(parameters)
            try storage.saveData(jsonData, forKey: storageKey)
            let user = parameters
            completionHandler(.success(user))
        } catch {
            completionHandler(.failure(error))
        }
    }
    
    func delete(entity: UserProfile, completionHandler: @escaping (Result<Void>) -> Void) {
        storage.removeObject(forKey: storageKey)
        completionHandler(.success(()))
    }
    
}
