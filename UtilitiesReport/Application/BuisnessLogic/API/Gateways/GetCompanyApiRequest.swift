//
//  GetCompanyApiRequest.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/28/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

struct GetCompanyApiRequest: ApiRequest {
    
    var identifier: String
    
    var urlRequest: URLRequest {
        let urlString = Constants.Api.apiURLString + "companies/\(identifier)"
        let url: URL = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        return request
    }
}
