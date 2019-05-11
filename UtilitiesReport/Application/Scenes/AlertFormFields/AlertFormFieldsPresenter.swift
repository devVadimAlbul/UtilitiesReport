//
//  AlertFormFieldsPresenter.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/10/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol AlertFormFieldsPresenter: PresenterProtocol {
    var saveCommand: CommandWith<AlertFormModel> { get set }
    var cancelCommand: Command { get set }
}

class AlertFormFieldsPresenterImpl: AlertFormFieldsPresenter {
  
    // MARK: property
    fileprivate weak var alertFormView: AlertFormFieldsView?
    fileprivate var model: AlertFormModel
    typealias Props = AlertFormFieldsViewController.Props
    var saveCommand: CommandWith<AlertFormModel>
    var cancelCommand: Command
    
    // MARK: life-cycle
    init(view: AlertFormFieldsView?, model: AlertFormModel,
         saveCommand: CommandWith<AlertFormModel>, cancelCommand: Command = .nop) {
        self.alertFormView = view
        self.model = model
        self.saveCommand = saveCommand
        self.cancelCommand = cancelCommand
    }
    
    func viewDidLoad() {
        presentProps()
    }
    
    private func presentProps(state: Props.PropsState = .edit) {
        alertFormView?.props = generateProps(state: state)
    }
    
    private func generateProps(state: Props.PropsState) -> Props {
        
        func getPropField(_ item: AlertFormModel.AlertFormField,
                          changed: @escaping (String?) -> Void) -> Props.ItemField {
            return Props.ItemField(
                placeholder: item.name,
                keyboardType: item.keyboardType,
                value: item.value,
                change: CommandWith<String?>(action: changed)
            )
        }
        
        var fields: [Props.ItemField] = []
        for index in 0..<model.fields.count {
            let field = getPropField(model.fields[index]) { [weak self] (value) in
                self?.model.fields[index].value = value
            }
            fields.append(field)
        }
        
        let props = Props(
            fields: fields,
            title: model.name,
            buttonSaveTitle: "Save",
            actionSave: Command(action: actionSave),
            actionCancel: cancelCommand,
            state: state
        )
        return props
    }

    private func actionSave() {
        presentProps(state: .loading)
        if let invalidMessage = checkModelValid() {
            presentProps(state: .falied(error: invalidMessage))
        } else {
            presentProps(state: .success)
            saveCommand.perform(with: model)
        }
    }
    
    private func checkModelValid() -> String? {
        for index in 0..<model.fields.count {
            let field = model.fields[index]
            if !(field.checkValid?(field.value) ?? false) {
                return field.invaidMessage
            }
        }
        return nil
    }
}
