//
//  HttpClient.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 4/7/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol HttpClient {
    func execute(request: ApiRequest,
                 completionHandler: @escaping (_ result: Result<ApiResponse<String>>) -> Void)
}

class HttpClientImpl: HttpClient {
    
    let urlSession: URLSessionProtocol
    
    init(urlSessionConfiguration: URLSessionConfiguration = .default,
         completionHandlerQueue: OperationQueue = .main) {
        urlSession = URLSession(configuration: urlSessionConfiguration,
                                delegate: nil, delegateQueue: completionHandlerQueue)
    }
    
    init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
    }
    
    func execute(request: ApiRequest, completionHandler: @escaping (Result<ApiResponse<String>>) -> Void) {
        let dataTask = urlSession.dataTask(with: request.urlRequest) { (data, response, error) in
            guard let httpUrlResponse = response as? HTTPURLResponse else {
                completionHandler(.failure(ApiError.networkRequestError(error)))
                return
            }
            
            let successRange = 200...299
            if successRange.contains(httpUrlResponse.statusCode) {
                do {
                    let response = try ApiResponse<String>(data: data, httpUrlResponse: httpUrlResponse)
                    completionHandler(.success(response))
                } catch {
                    completionHandler(.failure(error))
                }
            } else {
                completionHandler(.failure(NetworkApiError(data: data, httpUrlResponse: httpUrlResponse)))
            }
        }
        
        dataTask.resume()
    }
}
