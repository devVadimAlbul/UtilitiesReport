//
//  ApiTemplatesGateway.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/24/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol ApiTemplatesGateway: TemplatesGateway {
    
}

class ApiTemplatesGatewayImpl: ApiTemplatesGateway {

    
    private var apiClient: ApiClient
    
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    func load(by identifier: String, completionHandler: @escaping LoadEntityHandler) {
        let request = TemplateApiRequest.get(identifier)
        apiClient.execute(request: request) { (result: Result<ApiResponse<ApiTemplateReport>>) in
            switch result {
            case let .success(response):
                completionHandler(.success(response.entity.entity))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func fetch(company companyID: String, completionHandler: @escaping FetchEntitiesHandler) {
        let request = TemplateApiRequest.getList(companyID: companyID)
        apiClient.execute(request: request) { (result: Result<ApiResponse<[ApiTemplateReport]>>) in
            switch result {
            case let .success(response):
                let enities = response.entity.map({$0.entity})
                completionHandler(.success(enities))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
}
