//
//  SendReport.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/31/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol SendReportProtocol {
    func send(to params: TemplateReport, with content: String,
              completionHandler: @escaping (Result<Void>) -> Void)
}
