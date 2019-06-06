//
//  CompanyGateways.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/27/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation


protocol CompaniesGateway {
    typealias LoadEntityCompletionHandler = (_ result: Result<Company, Error>) -> Void
    typealias FetchEntitiesCompletionHandler = (_ result: Result<[Company], Error>) -> Void
    typealias AddEntityCompletionHandler = (_ result: Result<Company, Error>) -> Void
    typealias DeleteEntityCompletionHandler = (_ result: Result<Void, Error>) -> Void
    
    func load(by identifier: String, completionHandler: @escaping LoadEntityCompletionHandler)
    func fetch(completionHandler: @escaping FetchEntitiesCompletionHandler)
    func delete(entity: Company, completionHandler: @escaping DeleteEntityCompletionHandler)
    func deleteAll(completionHandler: @escaping (_ result: Result<Void, Error>) -> Void)
}


class CompaniesGatewayImpl: CompaniesGateway {
    let apiGateway: ApiCompaniesGateway
    let localStorageGateway: CompaniesLocalStorageGateway
    
    init(api: ApiCompaniesGateway, localStorage: CompaniesLocalStorageGateway) {
        self.apiGateway = api
        self.localStorageGateway = localStorage
    }
    
    func fetch(completionHandler: @escaping FetchEntitiesCompletionHandler) {
        apiGateway.fetch { [weak self] result in
            self?.handleFetchApiResult(result, completionHandler: completionHandler)
        }
    }
    
    func load(by identifier: String, completionHandler: @escaping LoadEntityCompletionHandler) {
        apiGateway.load(by: identifier) { [weak self, identifier] (result) in
            self?.handleLoadApiResult(result, with: identifier, completionHandler: completionHandler)
        }
    }
    
    func delete(entity: Company, completionHandler: @escaping DeleteEntityCompletionHandler) {
        apiGateway.delete(entity: entity) { [weak self, entity] (result) in
            self?.localStorageGateway.delete(entity: entity) { _ in }
            completionHandler(result)
        }
    }
    
    func deleteAll(completionHandler: @escaping (Result<Void, Error>) -> Void) {
        apiGateway.deleteAll { [weak self] (result) in
            self?.localStorageGateway.deleteAll { _ in }
            completionHandler(result)
        }
    }
    
    // MARK: private handles
    private func handleFetchApiResult(_ result: Result<[Company], Error>,
                                      completionHandler: @escaping FetchEntitiesCompletionHandler) {
        switch result {
        case let .success(companies):
            localStorageGateway.save(companis: companies, completionHandler: {_ in })
            completionHandler(result)
        case .failure:
            localStorageGateway.fetch(completionHandler: completionHandler)
        }
    }
    
    private func handleLoadApiResult(_ result: Result<Company, Error>, with identifier: String,
                                     completionHandler: @escaping LoadEntityCompletionHandler) {
        switch result {
        case .success(let company):
            localStorageGateway.save(companis: [company], completionHandler: {_ in })
            completionHandler(result)
        default:
            localStorageGateway.load(by: identifier, completionHandler: completionHandler)
        }
    }
}
