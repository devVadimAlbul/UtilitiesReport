//
//  SendReportModel.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 4/7/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation


struct SendReportModel {
    var type: TemplateType
    var sendTo: String
    var content: String
    var indicators: [IndicatorsCounter]
    
    
}
