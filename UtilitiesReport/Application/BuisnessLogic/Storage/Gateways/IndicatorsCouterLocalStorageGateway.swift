//
//  InticatorsCouterLocalStorageGateway.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/14/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol IndicatorsCouterLocalStorageGateway: IndicatorsCouterGateway {
    
}

class IndicatorsCouterLocalStorageGatewayImpl: IndicatorsCouterLocalStorageGateway {
    
    private var manager: RealmManagerProtocol
    
    init(manager: RealmManagerProtocol = RealmManager()) {
        self.manager = manager
    }
    
    func fetch(by predicate: NSPredicate, completionHandler: @escaping FetchEntitiesCompletionHandler) {
        let entites = manager.allEntities(withType: RealmIndicatorsCounter.self, predicate: predicate)
        let objects: [IndicatorsCounter] = entites.map({$0.indicatorsModel})
        completionHandler(.success(objects))
    }
    
    func delete(entity: IndicatorsCounter, completionHandler: @escaping DeleteEntityCompletionHandler) {
        if let object = getEntity(by: entity.identifier) {
            do {
                try manager.remove(object, cascading: true)
                completionHandler(.success(()))
            } catch {
                completionHandler(.failure(error))
            }
        }
        completionHandler(.failure(URError.idicatorCounterCantRemoved))
    }
    
    func deleteAll(by predicate: NSPredicate, completionHandler: @escaping DeleteEntityCompletionHandler) {
        let objects = manager.allEntities(withType: RealmIndicatorsCounter.self, predicate: predicate)
        do {
            try manager.remove(objects, cascading: true)
            completionHandler(.success(()))
        } catch {
            completionHandler(.failure(error))
        }
    }
    
    func save(entity: IndicatorsCounter, completionHandler: @escaping AddEntityCompletionHandler) {
        let object = RealmIndicatorsCounter(indicator: entity)
        do {
            try manager.save(object, update: true) {
                completionHandler(.success(entity))
            }
        } catch {
            completionHandler(.failure(error))
        }
    }
    
    private func getEntity(by identifier: String) -> RealmIndicatorsCounter? {
        return manager.getEntity(withType: RealmIndicatorsCounter.self, for: identifier)
    }
}
