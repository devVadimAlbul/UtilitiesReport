//
//  FormSendReportService.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/31/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol FormSendReportService: SendReportServiceProtocol {
    
}

class FormSendReportServiceImpl: FormSendReportService {
    private var client: ApiAlamofireClient
    
    init(client: ApiAlamofireClient) {
        self.client = client
    }
    
    func send(model: SendReportModel,
              completionHandler: @escaping (Result<SendReportStatus, Error>) -> Void) {
        guard let url = URL(string: model.sendTo) else {
            completionHandler(.failure(URError.urlInvalid))
            return
        }
        let request: ApiRequest
        do {
            request = try FormSendReportApiRequest(url: url, content: model.content)
        } catch {
            completionHandler(.failure(error))
            return
        }
        
        client.execute(request: request) { (result: Result<ApiResponse<String>, Error>) in
            switch result {
            case let .success(response):
                let resultR = self.checkResponse(response)
                completionHandler(resultR)
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
    
    private func checkResponse(_ response: ApiResponse<String>) -> Result<SendReportStatus, Error> {
        guard let data = response.data else { return .failure(URError.notAvailable("response")) }
    
        if let result = try? JSONSerialization.jsonObject(with:
            data, options: []),
            let json = result as? [String: Any] {
            if let code = json["code"] as? Int, code != 200 {
                return .failure(URError.notAvailable("response"))
            }
            if json.values.contains(where: {($0 as? String)?.contains("success") ?? false}) {
                return .success(.sent)
            }
        } else {
            if response.entity.contains("Дані успішно відправлено та найближчим часом будуть оброблені.") {
                return .success(.sent)
            }
        }
        return .success(.sent)
    }
}
