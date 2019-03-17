//
//  FormIndicatorCounterProps.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/16/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

extension FormIndicatorCounterViewController {
    
    struct Props {
        enum FieldState {
            case valid
            case invalid(message: String)
        }
        
        struct Field<T> {
            var name: String = ""
            var placeholder: String? = ""
            var value: String? = ""
            var change: CommandWith<T?> = .nop
            var state: FieldState = .valid
        }
        
        enum PageState {
            case edit
            case loading
            case falied(error: String)
            case success
        }
        
        var date: Field<Date>
        var selectedDate: Date
        var indicator: Field<String>
        var counter: Field<(Int, Int)>
        var isNeedCounter: Bool
        var selectedCounterItem: (row: Int, component: Int)?
        
        var pageTitle: String
        var state: PageState
        var buttonSaveTitle: String
        var commandSave: Command
        
        static var initial: Props = Props(date: Field<Date>(),
                                          selectedDate: Date(),
                                          indicator: Field<String>(),
                                          counter: Field<(Int, Int)>(),
                                          isNeedCounter: true,
                                          selectedCounterItem: nil,
                                          pageTitle: "",
                                          state: .edit,
                                          buttonSaveTitle: "",
                                          commandSave: .nop)
    }
    
}
