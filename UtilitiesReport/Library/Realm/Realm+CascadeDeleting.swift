//
//  Realm+CascadeDeleting.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/27/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import RealmSwift
import Realm

protocol CascadeDeleting: class {
    func delete<S: Sequence>(_ objects: S, cascading: Bool) where S.Iterator.Element: Object
    func delete<Entity: Object>(_ entity: Entity, cascading: Bool)
    func delete<S: Object>(_ objects: Results<S>, cascading: Bool)
}


extension Realm: CascadeDeleting {
    func delete<S: Sequence>(_ objects: S, cascading: Bool) where S.Iterator.Element: Object {
        for obj in objects {
            delete(obj, cascading: cascading)
        }
    }
    
    func delete<S: Object>(_ objects: Results<S>, cascading: Bool) {
        autoreleasepool {
            objects.forEach({ (obj) in
                delete(obj, cascading: cascading)
            })
        }
    }
    
    func delete<Entity: Object>(_ entity: Entity, cascading: Bool) {
        if cascading {
            cascadeDelete(entity)
        } else {
            delete(entity)
        }
    }
    
    private func cascadeDelete(_ entity: RLMObjectBase) {
        guard let entity = entity as? Object else { return }
        var toBeDeleted = Set<RLMObjectBase>()
        toBeDeleted.insert(entity)
        while !toBeDeleted.isEmpty {
            guard let element = toBeDeleted.removeFirst() as? Object,
                !element.isInvalidated else { continue }
            resolve(element: element, toBeDeleted: &toBeDeleted)
        }
    }
    
    private func resolve(element: Object, toBeDeleted: inout Set<RLMObjectBase>) {
        element.objectSchema.properties.forEach {
            guard let value = element.value(forKey: $0.name) else { return }
            if let entity = value as? RLMObjectBase {
                toBeDeleted.insert(entity)
            } else if let list = value as? RealmSwift.ListBase {
                for index in 0..<list._rlmArray.count {
                    if let objetc = list._rlmArray.object(at: index) as? RLMObjectBase {
                        toBeDeleted.insert(objetc)
                    }
                }
            }
        }
        delete(element)
    }
    
    func writeAsync<T: ThreadConfined>(obj: T,
                                       errorHandler: @escaping ((_ error: Swift.Error) -> Void) = { _ in return },
                                       block: @escaping ((Realm, T?) -> Void)) {
        DispatchQueue.main.async {
            let wrappedObj = ThreadSafeReference(to: obj)
            let config = self.configuration
            DispatchQueue.global().async {
                autoreleasepool {
                    do {
                        let realm = try Realm(configuration: config)
                        let obj = realm.resolve(wrappedObj)
                        
                        try realm.write {
                            block(realm, obj)
                        }
                    } catch {
                        errorHandler(error)
                    }
                }
            }
        }
    }
}
