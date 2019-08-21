//
//  FormTextItemView.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/11/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import UIKit

protocol FormTextItemViewDelegate: AnyObject {
    func didChangeFormText(view: FormTextItemView, at text: String?)
}

class FormTextItemView: ViewFromXib {

    // MARK: IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfItem: UITextField!
    @IBOutlet weak var lblWarning: UILabel!
    
    @IBOutlet var nextFormItem: FormTextItemView? {
        didSet {
            tfItem.nextField = nextFormItem?.tfItem
        }
    }
  @IBInspectable var isSecureTextEntry: Bool = false {
    didSet {
      tfItem.isSecureTextEntry = isSecureTextEntry
    }
  }
    
    // MARK: life-cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        tfItem.delegate = self
    }
    
    // MARK: property
    var identifier: String = ""
    weak var delegate: FormTextItemViewDelegate?
    var isValid: Bool = true {
        didSet { lblWarning.isHidden = isValid }
    }
    var title: String? {
        get { return lblTitle.text }
        set { lblTitle.text = newValue }
    }
    var value: String? {
        get { return tfItem.text }
        set { tfItem.text = newValue }
    }
    var placeholder: String? {
        get { return tfItem.placeholder }
        set { tfItem.placeholder = newValue }
    }
    var warningMessage: String? {
        get { return lblWarning.text }
        set { lblWarning.text = newValue }
    }
    var returnKeyType: UIReturnKeyType {
        get { return tfItem.returnKeyType }
        set { tfItem.returnKeyType = newValue }
    }
    var keyboardType: UIKeyboardType {
        get { return tfItem.keyboardType }
        set { tfItem.keyboardType = newValue }
    }
    
    // MARK: options
    @IBInspectable var titleColor: UIColor = .black {
        didSet { lblTitle.textColor = titleColor }
    }
    
    @IBInspectable var textColor: UIColor = .black {
        didSet { tfItem.textColor = textColor }
    }
    
    @IBInspectable var warningColor: UIColor = .red {
        didSet { lblWarning.textColor = warningColor }
    }
    
    // MARK: IBAction
    @IBAction func changedTfItem(_ sender: UITextField) {
        delegate?.didChangeFormText(view: self, at: sender.text)
    }
}

extension FormTextItemView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.nextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isValid = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.didChangeFormText(view: self, at: textField.text)
    }
}
