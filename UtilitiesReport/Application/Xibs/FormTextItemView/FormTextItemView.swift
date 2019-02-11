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
    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet var nextFormItem: FormTextItemView? {
        didSet {
            tfItem.nextField = nextFormItem?.tfItem
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
    var isOptional: Bool = false
    var isValid: Bool = true {
        didSet { lblWarning.isHidden = isOptional ? true : isValid }
    }
    var title: String? {
        didSet { lblTitle.text = title }
    }
    var value: String? {
        get { return tfItem.text }
        set { tfItem.text = newValue }
    }
    var placeholder: String? {
        didSet { tfItem.placeholder = placeholder }
    }
    var warningMessage: String? {
        didSet { lblWarning.text = warningMessage }
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
    @IBInspectable var borderColor: UIColor = .gray {
        didSet { borderView.backgroundColor = borderColor }
    }
    var returnKeyType: UIReturnKeyType {
        get { return tfItem.returnKeyType }
        set { tfItem.returnKeyType = newValue }
    }
    var keyboardType: UIKeyboardType {
        get { return tfItem.keyboardType }
        set { tfItem.keyboardType = newValue }
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
