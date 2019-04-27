//
//  UserUtilitesCompanyLocalStorageGateway.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/1/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol UserUtilCompanyLocalStorageGateway: UserUtilitesCompanyGateway {
    
}

class UserUtilCompanyLocalStorageGatewayImpl: UserUtilCompanyLocalStorageGateway {
    
    static var `default`: UserUtilCompanyLocalStorageGatewayImpl {
        return UserUtilCompanyLocalStorageGatewayImpl(manager: RealmManager())
    }
    
    private let manager: RealmManagerProtocol
    
    init(manager: RealmManagerProtocol) {
        self.manager = manager
    }
    
    func load(by identifier: String,
              completionHandler: @escaping LoadEntityCompletionHandler) {
        if let item = manager.getEntity(withType: RealmUserUtilitiesCompany.self, for: identifier) {
            let model = item.userCompanyModel
            completionHandler(.success(model))
        } else {
            completionHandler(.failure(URError.userCompanyNotFound))
        }
    }
    
    func fetch(completionHandler: @escaping FetchEntitiesCompletionHandler) {
        let items = manager.allEntities(withType: RealmUserUtilitiesCompany.self)
        let models: [UserUtilitiesCompany] = items.map({$0.userCompanyModel})
        completionHandler(.success(models))
    }
    
    func delete(entity: UserUtilitiesCompany,
                completionHandler: @escaping DeleteEntityCompletionHandler) {
        if let item = manager.getEntity(withType: RealmUserUtilitiesCompany.self,
                                        for: entity.accountNumber) {
            do {
                try manager.remove(item, cascading: true)
                completionHandler(.success(()))
            } catch {
                completionHandler(.failure(error))
            }
        } else {
            completionHandler(.success(()))
        }
    }
    
    func deleteAll(completionHandler: @escaping DeleteEntityCompletionHandler) {
        let items = manager.allEntities(withType: RealmUserUtilitiesCompany.self)
        do {
            try manager.remove(items, cascading: true)
            completionHandler(.success(()))
        } catch {
            completionHandler(.failure(error))
        }
    }
    
    func save(entity: UserUtilitiesCompany, by uuid: String?,
              completionHandler: @escaping AddEntityCompletionHandler) {
        
        let object = RealmUserUtilitiesCompany(userCompany: entity)
        do {
            if let uuid = uuid, uuid != object.accountNumber,
                let oldUserCompany = getUserCompany(by: uuid) {
                try manager.remove(oldUserCompany, cascading: false)
            }
            try manager.save(object, update: true, completion: {
                completionHandler(.success(object.objectCopy.userCompanyModel))
            })
        } catch {
            completionHandler(.failure(error))
        }
    }
    
    private func getUserCompany(by identifier: String) -> RealmUserUtilitiesCompany? {
        return manager.getEntity(withType: RealmUserUtilitiesCompany.self, for: identifier)
    }
}
