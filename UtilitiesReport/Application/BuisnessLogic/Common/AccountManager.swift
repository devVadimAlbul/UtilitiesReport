//
//  AccountManager.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/10/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

class AccountManager {
    
    fileprivate let storage: DefaultsStorage
    fileprivate let userStoreKey: String = "UR_User_Profile"
    
    init(storage: DefaultsStorage) {
        self.storage = storage
    }
    
    func getUser() -> UserProfile? {
        do {
            if let data = try storage.getData(forKey: userStoreKey) {
                let jsonDecoder = JSONDecoder()
                let user = try jsonDecoder.decode(UserProfile.self, from: data)
                return user
            }
        } catch {
            print("[AccountManager] get user error: ", error)
        }
        return nil
    }
    
    func saveUser(_ user: UserProfile) {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(user)
            try storage.saveData(jsonData, forKey: userStoreKey)
        } catch {
            print("[AccountManager] save user error: ", error)
        }
    }
    
    var isUserCreated: Bool {
        let user = getUser()
        return user != nil
    }
    
}
