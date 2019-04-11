//
//  SendReportServiceProtocol.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/31/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol SendReportServiceProtocol {
    func send(model: SendReportModel,
              completionHandler: @escaping (Result<Void>) -> Void)
}
