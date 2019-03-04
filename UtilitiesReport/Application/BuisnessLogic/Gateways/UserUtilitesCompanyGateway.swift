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
    func save(entity: UserUtilitiesCompany, completionHandler: @escaping AddEntityCompletionHandler)
}


class UserUtilitesCompanyGatewayImpl: UserUtilitesCompanyGateway {
    
    private let localStorage: UserUtilCompanyLocalStorageGateway
    
    init(localStorage: UserUtilCompanyLocalStorageGateway) {
        self.localStorage = localStorage
    }
    
    func load(by identifier: String, completionHandler: @escaping LoadEntityCompletionHandler) {
        
    }
    
    func fetch(completionHandler: @escaping FetchEntitiesCompletionHandler) {
        
    }
    
    func delete(entity: UserUtilitiesCompany, completionHandler: @escaping DeleteEntityCompletionHandler) {
        
    }
    
    func deleteAll(completionHandler: @escaping DeleteEntityCompletionHandler) {
        
    }
    
    func save(entity: UserUtilitiesCompany, completionHandler: @escaping AddEntityCompletionHandler) {
        
    }
}
