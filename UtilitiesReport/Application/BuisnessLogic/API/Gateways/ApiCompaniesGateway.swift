//
//  ApiCompaniesGateway.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/27/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol ApiCompaniesGateway: CompaniesGateway {
    
}

class ApiCompaniesGatewayImpl: ApiCompaniesGateway {
    let apiClient: ApiClient
    
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    func load(by identifier: String, completionHandler: @escaping ApiCompaniesGatewayImpl.LoadEntityCompletionHandler) {
        let request = CompanyApiRequest.get(identifier)
        apiClient.execute(request: request) { (result: Result<ApiResponse<ApiCompany>>) in
            switch result {
            case let .success(response):
                completionHandler(.success(response.entity.company))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func fetch(completionHandler: @escaping ApiCompaniesGatewayImpl.FetchEntitiesCompletionHandler) {
        let request = CompanyApiRequest.getAll
        apiClient.execute(request: request) { (result: Result<ApiResponse<[ApiCompany]>>) in
            switch result {
            case let .success(response):
                let companies = response.entity.map { return $0.company }
                completionHandler(.success(companies))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func deleteAll(completionHandler: @escaping (Result<Void>) -> Void) {
        completionHandler(.success(()))
    }
    
    func delete(entity: Company, completionHandler: @escaping ApiCompaniesGatewayImpl.DeleteEntityCompletionHandler) {
        completionHandler(.success(()))
    }
}
