//
//  ApiDownloadClient.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/25/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import Alamofire

protocol ApiDownloadClient {
    func download(request: ApiRequest,
                  progressHandler:  @escaping (Progress) -> Void,
                  completionHandler: @escaping (Result<URL>) -> Void)
}

class ApiDownloadClientImpl: ApiDownloadClient {
    
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
    
    func download(request: ApiRequest,
                  progressHandler:  @escaping (Progress) -> Void,
                  completionHandler: @escaping (Result<URL>) -> Void) {
        
         let destination: DownloadRequest.DownloadFileDestination
        
        if let url = request.urlRequest.url {
            let fileUrl = self.getSaveFileUrl(url)
            destination = { _, _ in
                return (fileUrl, [.removePreviousFile, .createIntermediateDirectories])
            }
        } else {
           destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        }
        
        Alamofire.download(request.urlRequest, to: destination)
            .downloadProgress(queue: .global(qos: .utility)) { (progress) in
                progressHandler(progress)
            }
            .responseData(queue: completionHandlerQueue) { (response) in
                if let destinationUrl = response.destinationURL {
                    completionHandler(.success(destinationUrl))
                } else {
                    completionHandler(.failure(ApiError.networkRequestError(response.error)))
                }
            }
    }
    
    private func getSaveFileUrl(_ url: URL) -> URL {
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        documentsURL.appendPathComponent("Templates", isDirectory: true)
        let fileURL = documentsURL.appendingPathComponent(url.lastPathComponent)
        return fileURL
    }
}
