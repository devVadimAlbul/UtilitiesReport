//
//  CompaniesApiRequest.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/27/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation


enum CompanyApiRequest: ApiRequest {
    case getAll
    case get(String)
    
    var urlRequest: URLRequest {
        switch self {
        case .getAll:
            return CompaniesApiRequest().urlRequest
        case .get(let identifier):
            return GetCompanyApiRequest(identifier: identifier).urlRequest
        }
    }
}

private struct CompaniesApiRequest: ApiRequest {
    
    var urlRequest: URLRequest {
        let urlString = Constants.Api.apiURLString + "companies"
        let url: URL = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        return request
    }
}

private struct GetCompanyApiRequest: ApiRequest {
    var identifier: String
    var urlRequest: URLRequest {
        let urlString = Constants.Api.apiURLString + "companies/\(identifier)"
        let url: URL = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        return request
    }
}
