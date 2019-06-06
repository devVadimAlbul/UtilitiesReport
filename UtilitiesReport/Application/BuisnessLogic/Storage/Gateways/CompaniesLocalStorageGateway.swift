//
//  CompaniesLocalStorageGateway.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/27/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import RealmSwift

protocol CompaniesLocalStorageGateway: CompaniesGateway {
    func save(companis: [Company], completionHandler: @escaping (_ result: Result<Void, Error>) -> Void)
    
}

class CompaniesLocalStorageGatewayImpl: CompaniesLocalStorageGateway {
 
    let manager: RealmManagerProtocol
    
    init(manager: RealmManagerProtocol) {
        self.manager = manager
    }
    
    func load(by identifier: String,
              completionHandler: @escaping CompaniesLocalStorageGatewayImpl.LoadEntityCompletionHandler) {
        if let item = getEntity(by: identifier) {
            completionHandler(.success(item.companyModel))
        } else {
            completionHandler(.failure(URError.companyNotFound))
        }
    }
    
    func fetch(completionHandler: @escaping CompaniesLocalStorageGatewayImpl.FetchEntitiesCompletionHandler) {
        let companies = manager.allEntities(withType: RealmCompany.self)
        let companiesModel: [Company] = companies.map({$0.companyModel})
        completionHandler(.success(companiesModel))
    }

    
    func delete(entity: Company,
                completionHandler: @escaping CompaniesLocalStorageGatewayImpl.DeleteEntityCompletionHandler) {
        if let item = getEntity(by: entity.identifier) {
            do {
                try manager.remove(item, cascading: false)
                completionHandler(.success(()))
            } catch {
                completionHandler(.failure(error))
            }
        } else {
            completionHandler(.success(()))
        }
    }
    
    func deleteAll(completionHandler: @escaping (_ result: Result<Void, Error>) -> Void) {
        let objects = manager.allEntities(withType: RealmCompany.self)
        do {
            try manager.remove(objects, cascading: true)
            completionHandler(.success(()))
        } catch {
            completionHandler(.failure(error))
        }
    }
    
    func save(companis: [Company], completionHandler: @escaping (_ result: Result<Void, Error>) -> Void) {
        let realmCompanies = companis.map({RealmCompany(company: $0)})
        do {
            try manager.save(realmCompanies, update: true) {
                completionHandler(.success(()))
            }
        } catch {
            completionHandler(.failure(error))
        }
    }
    
    // MARK: privatre methods
    private func getEntity(by identifier: String) -> RealmCompany? {
        return manager.getEntity(withType: RealmCompany.self, for: identifier)
    }
}
