//
//  TemplatesGateway.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/24/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol TemplatesGateway {
    typealias LoadEntityHandler = (_ result: Result<TemplateReport>) -> Void
    typealias FetchEntitiesHandler = (_ result: Result<[TemplateReport]>) -> Void
    
    func load(by identifier: String, completionHandler: @escaping LoadEntityHandler)
    func fetch(company companyID: String, completionHandler: @escaping FetchEntitiesHandler)
}


class TemplatesGatewayImpl: TemplatesGateway {
    
    private var apiGateway: ApiTemplatesGateway
    
    init(apiGateway: ApiTemplatesGateway) {
        self.apiGateway = apiGateway
    }
    
    func load(by identifier: String, completionHandler: @escaping LoadEntityHandler) {
        apiGateway.load(by: identifier, completionHandler: completionHandler)
    }
    
    func fetch(company companyID: String, completionHandler: @escaping FetchEntitiesHandler) {
        apiGateway.fetch(company: companyID, completionHandler: completionHandler)
    }
    
}
