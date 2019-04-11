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
    
    func save(entities: [IndicatorsCounter], completionHandler: @escaping AddEntitiesCompletionHandler) {
        let realmCompanies = entities.map({RealmIndicatorsCounter(indicator: $0)})
        do {
            try manager.save(realmCompanies, update: true) {
                completionHandler(.success(entities))
            }
        } catch {
            completionHandler(.failure(error))
        }
    }
    
    func add(entity: IndicatorsCounter, toUserCompanyID identifier: String,
             completionHandler: @escaping AddEntityCompletionHandler) {
        if let company = manager.getEntity(withType: RealmUserUtilitiesCompany.self,
                                           for: identifier) {
            let indicator = RealmIndicatorsCounter(indicator: entity)
            do {
                try manager.write { realm in
                    realm.add(indicator, update: true)
                    company.indicators.append(indicator)
                    completionHandler(.success(entity))
                }
            } catch {
                completionHandler(.failure(error))
            }
        } else {
             completionHandler(.failure(URError.userCompanyNotFound))
        }
    }
    
    private func getEntity(by identifier: String) -> RealmIndicatorsCounter? {
        return manager.getEntity(withType: RealmIndicatorsCounter.self, for: identifier)
    }
}
