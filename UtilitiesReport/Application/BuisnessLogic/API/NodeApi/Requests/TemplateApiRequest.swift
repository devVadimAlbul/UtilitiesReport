//
//  DownloadApiRequest.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/25/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

enum TemplateApiRequest: ApiRequest {
    case get(String)
    case getList(companyID: String)
    case download(String)
    
    var urlRequest: URLRequest {
        switch self {
        case .get(let identifier):
            return GetTemplateApiRequest(identifier: identifier).urlRequest
        case .getList(let companyID):
            return GetTemplatesCompanyApiRequest(companyID: companyID).urlRequest
        case .download(let path):
            return DownloadTemplateApiRequest(path: path).urlRequest
        }
    }
}


private struct GetTemplatesCompanyApiRequest: ApiRequest {
    var companyID: String
    var urlRequest: URLRequest {
        let urlString = Constants.Api.apiURLString + "templates?_expand=company&companyId=\(companyID)"
        let url: URL = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        return request
    }
}

private struct GetTemplateApiRequest: ApiRequest {
    var identifier: String
    var urlRequest: URLRequest {
        let urlString = Constants.Api.apiURLString + "templates/\(identifier)?_expand=company"
        let url: URL = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        return request
    }
}


private struct DownloadTemplateApiRequest: ApiRequest {
    var path: String
    var urlRequest: URLRequest {
        let urlString = Constants.Api.apiURLString + path
        let url: URL = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        return request
    }
}
