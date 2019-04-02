//
//  FormSendReport.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/31/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation


private struct FormSendReportApiRequest: ApiRequest {
    
    var url: URL
    var contentData: Data
    
    
    init(url: URL, content: String) throws {
        self.contentData = try JSONSerialization.data(withJSONObject: content, options: [])
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

protocol FormSendReport: SendReportProtocol {
    
}

class FormSendReportImpl: FormSendReport {
    private var apiClient: ApiClient
    
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    func send(to params: TemplateReport, with content: String,
              completionHandler: @escaping (Result<Void>) -> Void) {
        guard let url = params.sendToURL else {
            completionHandler(.failure(URError.urlInvalid))
            return
        }
        let request: ApiRequest
        do {
            request = try FormSendReportApiRequest(url: url, content: content)
        } catch {
            completionHandler(.failure(error))
            return
        }
        
        apiClient.execute(request: request) { (result: Result<ApiResponse<ApiResponseEmpty>>) in
            switch result {
            case .success:
                print("[FormSendReport] success")
                completionHandler(.success(()))
            case let .failure(error):
                print(error)
                completionHandler(.failure(error))
            }
        }
    }
}
