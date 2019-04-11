//
//  ApiDownloadTemplateGateway.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/25/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol ApiDownloadTemplateGateway {
    typealias DownloadCompletionHandler = (_ result: Result<String>) -> Void
    typealias DownloadProgressHandler = (Progress) -> Void
    
    func download(parameter: TemplateReport,
                  progressHandler: @escaping DownloadProgressHandler,
                  complationHandler: @escaping DownloadCompletionHandler)
}

class ApiDownloadTemplateGatewayImpl: ApiDownloadTemplateGateway {
    
    private var apiDownloadClient: ApiDownloadClient
    
    init(apiDownloadClient: ApiDownloadClient) {
        self.apiDownloadClient = apiDownloadClient
    }
    
    func download(parameter: TemplateReport,
                  progressHandler: @escaping DownloadProgressHandler,
                  complationHandler: @escaping DownloadCompletionHandler) {
        
        let request = TemplateApiRequest.download(parameter.templateUrlString)
        apiDownloadClient.download(request: request,
                                   progressHandler: progressHandler,
                                   completionHandler: { (result) in
                switch result {
                case let .success(url):
                    do {
                        let content = try String(contentsOf: url)
                        complationHandler(.success(content))
                    } catch {
                        complationHandler(.failure(error))
                    }
                case let .failure(error):
                    complationHandler(.failure(error))
                }
        })
    }
    
    class var `default`: ApiDownloadTemplateGateway {
        let apiDownload = ApiDownloadClientImpl()
        return ApiDownloadTemplateGatewayImpl(apiDownloadClient: apiDownload)
    }
}
