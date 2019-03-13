//
//  DefaultsStorage.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/10/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol DefaultsStorage: AnyObject, StorageProvidable {}

// sourcery:begin: AutoMockable
extension DefaultsStorage {}
// sourcery:end

class DefaultsStorageImpl: DefaultsStorage {
    
    private let describing: UserDefaultsDescribing
    
    init(describing: UserDefaultsDescribing = UserDefaults.standard) {
        self.describing = describing
    }
    
    func saveValue(_ value: String?, forKey key: String) throws {
        describing.set(value, forKey: key)
        _ = describing.synchronize()
    }
    
    func saveData(_ data: Data?, forKey key: String) throws {
        describing.set(data, forKey: key)
        _ = describing.synchronize()
    }
    
    func getValue(forKey key: String) throws -> String? {
        return describing.value(forKey: key) as? String
    }
    
    func getData(forKey key: String) throws -> Data? {
        return describing.value(forKey: key) as? Data
    }
    
    func removeObject(forKey key: String) {
        describing.removeObject(forKey: key)
        _ = describing.synchronize()
    }
    
}
