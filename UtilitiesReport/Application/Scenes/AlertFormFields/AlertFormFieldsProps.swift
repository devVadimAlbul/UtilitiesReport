//
//  AlertFormFieldsProps.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/10/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

extension AlertFormFieldsViewController {
    
    struct Props {
        enum PropsState {
            case edit
            case loading
            case falied(error: String)
            case success
        }
        
        struct ItemField {
            var placeholder: String
            var value: String?
            var change: CommandWith<String?>
            
            static var initial: ItemField = ItemField(placeholder: "", value: nil, change: .nop)
        }
        
        var fields: [ItemField]
        var title: String
        var buttonSaveTitle: String
        var actionSave: Command
        var actionCancel: Command
        var state: PropsState
        
        static var initial: Props = Props(fields: [], title: "", buttonSaveTitle: "",
                                          actionSave: .nop, actionCancel: .nop, state: .edit)
    }
}
