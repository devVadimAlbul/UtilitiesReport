//
//  UserUtilitesCompanyGateway.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/1/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol UserUtilitesCompanyGateway {
    typealias LoadEntityCompletionHandler = (_ result: Result<UserUtilitiesCompany>) -> Void
    typealias FetchEntitiesCompletionHandler = (_ result: Result<[UserUtilitiesCompany]>) -> Void
    typealias AddEntityCompletionHandler = (_ result: Result<UserUtilitiesCompany>) -> Void
    typealias DeleteEntityCompletionHandler = (_ result: Result<Void>) -> Void
    
    func load(by identifier: String, completionHandler: @escaping LoadEntityCompletionHandler)
    func fetch(completionHandler: @escaping FetchEntitiesCompletionHandler)
    func delete(entity: UserUtilitiesCompany, completionHandler: @escaping DeleteEntityCompletionHandler)
    func deleteAll(completionHandler: @escaping DeleteEntityCompletionHandler)
    func save(entity: UserUtilitiesCompany, by uuid: String?, completionHandler: @escaping AddEntityCompletionHandler)
}


class UserUtilitesCompanyGatewayImpl: UserUtilitesCompanyGateway {
    
    private let localStorage: UserUtilCompanyLocalStorageGateway
    
    init(localStorage: UserUtilCompanyLocalStorageGateway) {
        self.localStorage = localStorage
    }
    
    func load(by identifier: String, completionHandler: @escaping LoadEntityCompletionHandler) {
        localStorage.load(by: identifier, completionHandler: completionHandler)
    }
    
    func fetch(completionHandler: @escaping FetchEntitiesCompletionHandler) {
        localStorage.fetch(completionHandler: completionHandler)
    }
    
    func delete(entity: UserUtilitiesCompany, completionHandler: @escaping DeleteEntityCompletionHandler) {
        localStorage.delete(entity: entity, completionHandler: completionHandler)
    }
    
    func deleteAll(completionHandler: @escaping DeleteEntityCompletionHandler) {
        localStorage.deleteAll(completionHandler: completionHandler)
    }
    
    func save(entity: UserUtilitiesCompany, by uuid: String?, completionHandler: @escaping AddEntityCompletionHandler) {
        localStorage.save(entity: entity, by: uuid, completionHandler: completionHandler)
    }
}
