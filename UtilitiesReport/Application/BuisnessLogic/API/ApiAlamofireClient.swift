//
//  ApiAlamofireClient.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/24/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import Alamofire

protocol ApiAlamofireClient: ApiClient {
    
}

class ApiAlamofireClientImpl: ApiAlamofireClient {
    
    #if DEBUG
    let isDebugMode = true
    #else
    let isDebugMode = false
    #endif
    
    private let logName: String = "\n*** ApiAlamofireClient"
    private var completionHandlerQueue: DispatchQueue
    
    init(completionHandlerQueue: DispatchQueue = .main) {
        self.completionHandlerQueue = completionHandlerQueue
    }
    
    func execute<T>(request: ApiRequest,
                    completionHandler: @escaping (Result<ApiResponse<T>>) -> Void) where T: Decodable {
        
        let requestData = Alamofire.request(request.urlRequest)
            .validate(statusCode: 200..<500).validate(statusCode: 200..<500)
            .responseJSON { (response) in
                self.debugResponceJSON(response: response, description: request.urlRequest.description)
            }.response(queue: completionHandlerQueue) { (response) in
                guard let httpUrlResponse = response.response else {
                    completionHandler(.failure(ApiError.networkRequestError(response.error)))
                    return
                }
                let successRange = 200...299
                if successRange.contains(httpUrlResponse.statusCode) {
                    do {
                        let result = try ApiResponse<T>(data: response.data, httpUrlResponse: httpUrlResponse)
                        completionHandler(.success(result))
                    } catch {
                        completionHandler(.failure(error))
                    }
                } else {
                    completionHandler(.failure(NetworkApiError(data: response.data, httpUrlResponse: httpUrlResponse)))
                }
        }
        
        if isDebugMode {
            print("\(logName) request request  \(requestData.request?.description ?? "")")
            debugPrint(request)
        }
    }
    
    private func debugResponceJSON(response: DataResponse<Any>, description: String) {
        if isDebugMode {
            print("\(logName) request responce \(description)")
            debugPrint(response)
        }
        
        switch response.result {
        case .success: break
        case .failure(let error):
            if isDebugMode {
                if let data = response.data {
                    print("request responce body \(String(data: data, encoding: String.Encoding.utf8) ?? "")")
                    print("=============\n")
                }
                print(error.localizedDescription)
            }
        }
    }
}
