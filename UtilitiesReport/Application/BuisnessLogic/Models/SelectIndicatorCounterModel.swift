//
//  SelectIndicatorCounterModel.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 5/5/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

struct SelectIndicatorCounterModel {
    var counter: Counter
    var selectedIndicator: IndicatorsCounter?
    var listIndicators: [IndicatorsCounter]
    var isValid: Bool = false
}
