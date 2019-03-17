//
//  InputFormItemTableViewCell.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/8/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import UIKit

protocol InputFormItemDelegate: AnyObject {
    func inputFormItem(_ view: InputFormItemViewCell, didChangeVlaue value: String?)
}

protocol InputFormItemViewCell: BasicVeiwCellProtocol {
    func displayTitle(_ title: String)
    func displayValue(_ text: String?)
    func displayPlaceholder(_ placeholder: String?)
    func displayWarningMessage(_ message: String?, isShow: Bool)
    func setKeyboardType(_ keyboardType: UIKeyboardType)
    var delegate: InputFormItemDelegate? { get set }
    var identifier: String? { get set }
}


class InputFormItemTableViewCell: UITableViewCell, InputFormItemViewCell {

    // MARK: IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfContent: UITextField!
    @IBOutlet weak var lblWarning: UILabel!
    
    // MARK: property
    weak var delegate: InputFormItemDelegate?
    var identifier: String?
    private var isValid: Bool = true {
        didSet {
            lblWarning.isHidden = isValid
            if isValid != oldValue {
                setNeedsDisplay()
            }
        }
    }
    
    // MARK: life-cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        tfContent.addTarget(self, action: #selector(tfContentValueChanged(_:)), for: .editingChanged)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isValid = true
    }
    
    // MARK: display methods
    func displayTitle(_ title: String) {
        lblTitle.text = title
    }
    
    func displayValue(_ text: String?) {
        tfContent.text = text
    }
    
    func displayPlaceholder(_ placeholder: String?) {
        tfContent.placeholder = placeholder
    }
    
    func displayWarningMessage(_ message: String?, isShow: Bool) {
        lblWarning.text = message
        isValid = !isShow
        setNeedsDisplay()
    }
    
    func setKeyboardType(_ keyboardType: UIKeyboardType) {
        tfContent.keyboardType = keyboardType
    }
    
    // MARK: selectors methods,
    @objc func tfContentValueChanged(_ sender: UITextField) {
        isValid = true
        delegate?.inputFormItem(self, didChangeVlaue: sender.text)
    }
}
