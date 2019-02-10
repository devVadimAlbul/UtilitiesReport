//
//  DefaultsStorage.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/10/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol DefaultsStorage: AnyObject, StoringProvidable {}

class DefaultsStorageImpl: DefaultsStorage {
    
    private let storage: UserDefaultsDescribing
    
    init(storage: UserDefaultsDescribing = UserDefaults.standard) {
        self.storage = storage
    }
    
    func saveValue(_ value: String?, forKey key: String) throws {
        storage.set(value, forKey: key)
        _ = storage.synchronize()
    }
    
    func saveData(_ data: Data?, forKey key: String) throws {
        storage.set(data, forKey: key)
        _ = storage.synchronize()
    }
    
    func getValue(forKey key: String) throws -> String? {
        return storage.value(forKey: key) as? String
    }
    
    func getData(forKey key: String) throws -> Data? {
        return storage.value(forKey: key) as? Data
    }
    
    
}
