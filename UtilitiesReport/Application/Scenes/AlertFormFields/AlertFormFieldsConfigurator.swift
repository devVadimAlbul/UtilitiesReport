//
//  AlertFormFieldsConfigurator.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/10/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol AlertFormFieldsConfigurator {
    func configure(viewController: AlertFormFieldsViewController)
}

class AlertFormFieldsConfiguratorImpl: AlertFormFieldsConfigurator {
    
    fileprivate var model: AlertFormModel
    fileprivate var saveCommand: CommandWith<AlertFormModel>
    fileprivate var cancelCommand: Command
    init(model: AlertFormModel,
         saveCommand: CommandWith<AlertFormModel>,
         cancelCommand: Command = .nop) {
        self.saveCommand = saveCommand
        self.cancelCommand = cancelCommand
        self.model = model
    }
    
    func configure(viewController: AlertFormFieldsViewController) {
        let presenter = AlertFormFieldsPresenterImpl(view: viewController,
                                                     model: model,
                                                     saveCommand: saveCommand,
                                                     cancelCommand: cancelCommand)
        
        viewController.presenter = presenter
    }
}
