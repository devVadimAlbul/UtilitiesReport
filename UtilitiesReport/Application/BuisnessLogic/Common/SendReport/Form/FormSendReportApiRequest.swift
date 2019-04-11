//
//  FormSendReportApiRequest.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 4/6/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation


struct FormSendReportApiRequest: ApiRequest {
    
    var url: URL
    var contentData: Data
    
    
    init(url: URL, content: String) throws {
        guard let data = content.data(using: .utf8),
            let dir = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            throw URError.reportNotSend
        }
        self.contentData = try JSONSerialization.data(withJSONObject: dir, options: [])
        self.url = url
    }
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = contentData
        
        return request
    }
}
