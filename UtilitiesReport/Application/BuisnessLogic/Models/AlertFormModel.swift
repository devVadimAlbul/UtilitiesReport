//
//  AlertFormModel.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/10/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import UIKit.UITextInput

struct AlertFormModel {
    struct AlertFormField {
        let identifier: String
        var name: String
        var value: String?
        var keyboardType: UIKeyboardType = .default
        var checkValid: ((String?) -> Bool)?
        var invaidMessage: String = ""
    }
    
    let identifier: String
    var name: String
    var fields: [AlertFormField]
    
    func getFieldValue(by identifier: String) -> String? {
        return fields.first(where: {$0.identifier == identifier})?.value
    }
}
