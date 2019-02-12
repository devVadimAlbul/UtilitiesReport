//
//  UserFormViewController.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/10/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import UIKit

protocol UserFormView: AnyObject {
    var configurator: UserFormConfigurator! { get }
    func displayPageTitle(_ title: String)
    func displayForm(_ model: UserProfileFormModalView)
    func updateFormItem(id: String, isValid: Bool)
    func displayError(message: String)
    func displaySuccessSave()
}

class UserFormViewController: BasicViewController, UserFormView {
    
    // MARK:
    @IBOutlet var formItems: [FormTextItemView]!
    @IBOutlet weak var btnSave: ButtonRound!
    
    // MARK: property
    var configurator: UserFormConfigurator!
    var formPresenter: UserFormPresenter? {
        return presneter as? UserFormPresenter
    }

    override func viewDidLoad() {
        configurator.configure(view: self)
        super.viewDidLoad()
    }
    
    // MARK: display methods
    func displayPageTitle(_ title: String) {
        self.title = title
    }
    
    func displayForm(_ model: UserProfileFormModalView) {
        formItems.enumerated().forEach { (index, formItem) in
            formItem.delegate = self
            if model.items.indices.contains(index) {
                let itemModel = model.items[index]
                formItem.title = itemModel.title
                formItem.identifier = itemModel.identifier
                formItem.placeholder = itemModel.placeholder
                formItem.value = itemModel.value
                formItem.isOptional = itemModel.isOptional
                formItem.warningMessage = itemModel.warningMessage
                formItem.isValid = true
                formItem.returnKeyType = .next
                formItem.keyboardType = itemModel.keyboardType
            }
        }
        formItems.last?.returnKeyType = .done
    }
    
    func updateFormItem(id: String, isValid: Bool) {
        ProgressHUD.dismiss()
        guard let item = formItems.first(where: {$0.identifier == id}) else { return }
        item.isValid = isValid
    }
    
    func displaySuccessSave() {
        ProgressHUD.success("Save success!", withDelay: 0.5)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            if let count = self.navigationController?.viewControllers.count, count > 1 {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
          
        }
    }
    
    func displayError(message: String) {
        ProgressHUD.dismiss()
        showErrorAlert(message: message)
    }
    
    // MARK: IBAction
    @IBAction func clickedBtnSave(_ sender: Any) {
        ProgressHUD.show()
        formPresenter?.saveFormContent()
    }
}

// MARK: - extension: FormTextItemViewDelegate
extension UserFormViewController: FormTextItemViewDelegate {
    
    func didChangeFormText(view: FormTextItemView, at text: String?) {
        formPresenter?.changeFormItem(value: text, by: view.identifier)
    }
}
