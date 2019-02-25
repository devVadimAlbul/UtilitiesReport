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
    var props: UserFormViewController.Props { get set }
}

class UserFormViewController: BasicViewController, UserFormView {
    
    enum FormItemType: String {
        case firstName
        case lastName
        case phoneNumber
        case email
        case city
        case street
        case house
        case apartment
    }

    // MARK: IBOutlet
    @IBOutlet weak var btnSave: ButtonRound!
    @IBOutlet weak var tfFirstName: FormTextItemView!
    @IBOutlet weak var tfLastName: FormTextItemView!
    @IBOutlet weak var tfPhoneNumber: FormTextItemView!
    @IBOutlet weak var tfEmail: FormTextItemView!
    @IBOutlet weak var tfCity: FormTextItemView!
    @IBOutlet weak var tfStreet: FormTextItemView!
    @IBOutlet weak var tfHouse: FormTextItemView!
    @IBOutlet weak var tfApartment: FormTextItemView!
    
    // MARK: property
    var configurator: UserFormConfigurator!
    var props: UserFormViewController.Props = .initial {
        didSet {
            render(props: props)
        }
    }
    
    override func viewDidLoad() {
        configurator.configure(view: self)
        super.viewDidLoad()
        setupUIContent()
    }
    
    // MARK: setup UI
    private func setupUIContent() {
        setTextViewParams(in: tfFirstName, with: .firstName, nextView: tfLastName)
        setTextViewParams(in: tfLastName, with: .lastName, nextView: tfPhoneNumber)
        setTextViewParams(in: tfPhoneNumber, with: .phoneNumber, keyboard: .phonePad, nextView: tfEmail)
        setTextViewParams(in: tfEmail, with: .email, keyboard: .emailAddress, nextView: tfCity)
        setTextViewParams(in: tfCity, with: .city, nextView: tfStreet)
        setTextViewParams(in: tfStreet, with: .street, nextView: tfHouse)
        setTextViewParams(in: tfHouse, with: .house, nextView: tfApartment)
        setTextViewParams(in: tfApartment, with: .apartment, keyboard: .asciiCapableNumberPad)
    }
    
    private func setTextViewParams(in textView: FormTextItemView, with identifire: FormItemType,
                                   keyboard: UIKeyboardType = .default, nextView: FormTextItemView? = nil) {
        textView.identifier = identifire.rawValue
        textView.keyboardType = keyboard
        textView.returnKeyType = nextView == nil ? .done : .next
        textView.nextFormItem = nextView
        textView.delegate = self
    }
    
    // MARK: update UI
    private func render(props: Props) {
        self.navigationItem.title = props.pageTitle
        btnSave.setTitle(props.saveButtonTitle, for: .normal)
        updateContentTextView(in: tfFirstName, with: props.firstName)
        updateContentTextView(in: tfLastName, with: props.lastName)
        updateContentTextView(in: tfPhoneNumber, with: props.phoneNumber)
        updateContentTextView(in: tfEmail, with: props.email)
        updateContentTextView(in: tfCity, with: props.city)
        updateContentTextView(in: tfStreet, with: props.street)
        updateContentTextView(in: tfHouse, with: props.house)
        updateContentTextView(in: tfApartment, with: props.apartment)
        
        switch props.state {
        case .edit: ProgressHUD.dismiss()
        case .falied(error: let error):
            ProgressHUD.dismiss()
            showErrorAlert(message: error)
        case .loading:
            ProgressHUD.show(mesage: "Loading...")
        case .success:
            ProgressHUD.success("Save success!", withDelay: 0.5)
        }
        view.setNeedsLayout()
    }
    
    private func updateContentTextView(in textView: FormTextItemView, with item: Props.Item) {
        textView.placeholder = item.placeholder
        textView.title = item.name
        switch item.state {
        case .valid:
            textView.isValid = true
        case .invalid(message: let message):
            textView.warningMessage = message
            textView.isValid = false
        }
        updateTextIfNeeded(in: textView, with: item, using: \.value)
    }
    private func updateTextIfNeeded<T>(in textView: FormTextItemView,
                                       with source: T,
                                       using keyPath: KeyPath<T, String?>) {
        guard !textView.tfItem.isFirstResponder else { return }
        textView.value = source[keyPath: keyPath]
    }
    
    // MARK: change props
    fileprivate func changePropsItem(_ item: Props.Item, at text: String?) {
        item.change.perform(with: text)
    }

    
    // MARK: IBAction
    @IBAction func clickedBtnSave(_ sender: Any) {
        props.actionSave.perform()
    }
}

// MARK: - extension: FormTextItemViewDelegate
extension UserFormViewController: FormTextItemViewDelegate {
    
    func didChangeFormText(view: FormTextItemView, at text: String?) {
        guard let formItemType = FormItemType(rawValue: view.identifier) else { return }
        switch formItemType {
        case .firstName:
            changePropsItem(props.firstName, at: text)
        case .lastName:
            changePropsItem(props.lastName, at: text)
        case .phoneNumber:
            changePropsItem(props.phoneNumber, at: text)
        case .email:
            changePropsItem(props.email, at: text)
        case .city:
            changePropsItem(props.city, at: text)
        case .street:
            changePropsItem(props.street, at: text)
        case .house:
            changePropsItem(props.house, at: text)
        case .apartment:
            changePropsItem(props.apartment, at: text)
        }
    }
}
