//
//  SendReportHelper.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 4/7/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit.UIViewController

protocol SendReportHelper {
    func send(model: SendReportModel, in controller: UIViewController,
              completionHandler: @escaping (Result<Void>) -> Void)
}


class SendReportHelperImpl: SendReportHelper {
    
    func send(model: SendReportModel, in controller: UIViewController,
              completionHandler: @escaping (Result<Void>) -> Void) {
      
        if let service = getReportService(with: model.type, in: controller) {
            service.send(model: model) { (result) in
                switch result {
                case .success:
                    print("success")
                    completionHandler(.success(()))
                case let .failure(error):
                    print("Error: ", error)
                    completionHandler(.failure(error))
                }
            }
        } else {
            completionHandler(.failure(URError.reportNotSend))
        }
    }
    
    private func getReportService(with type: TemplateType,
                                  in controller: UIViewController) -> SendReportServiceProtocol? {
        switch type {
        case .form:
            return FormSendReportServiceImpl(client: HttpClientImpl())
        default:
            return nil
        }
    }
    
}
