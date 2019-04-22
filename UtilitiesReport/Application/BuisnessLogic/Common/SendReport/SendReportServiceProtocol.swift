//
//  SendReportServiceProtocol.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/31/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

enum SendReportStatus {
    case sent
    case cancelled
}


protocol SendReportServiceProtocol {
    func send(model: SendReportModel,
              completionHandler: @escaping (Result<SendReportStatus>) -> Void)
}
