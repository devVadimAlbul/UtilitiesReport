//
//  SelectorFormItemTableViewCell.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/6/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import UIKit

protocol SelectorFormItemDelegate: AnyObject {
    func selectorFormItem(_ view: SelectorFormItemViewCell, didSelectIndex index: Int, in list: [String])
}

protocol SelectorFormItemViewCell: BasicVeiwCellProtocol {
    func displayTitle(_ title: String)
    func displayValue(_ text: String?)
    func displayPlaceholder(_ placeholder: String?)
    func displayWarningMessage(_ message: String?, isShow: Bool)
    func displayListItems(_ list: [String], selectedIndex: Int?)
    var delegate: SelectorFormItemDelegate? { get set }
    var identifier: String? { get set }
}

class SelectorFormItemTableViewCell: UITableViewCell, SelectorFormItemViewCell {
    
    // MARK: IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfContent: UITextField!
    @IBOutlet weak var lblWarning: UILabel!
    
    // MARK: preoprty
    weak var delegate: SelectorFormItemDelegate?
    var identifier: String?
    
    private var pickerView: UIPickerView = UIPickerView()
    private var listItems: [String] = []
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tfContent.inputView = pickerView
        pickerView.delegate = self
        pickerView.backgroundColor = .white
        pickerView.dataSource = self
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        tfContent.addImage(in: .right,
                           with: #imageLiteral(resourceName: "arrow-down"),
                           to: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)),
                           backgroundColor: .clear,
                           tintColor: .gray)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
    
    func displayListItems(_ list: [String], selectedIndex: Int? = nil) {
        self.listItems = list
        pickerView.reloadAllComponents()
        if let selectedIndex = selectedIndex, list.count > selectedIndex {
            pickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
            tfContent.text = listItems[selectedIndex]
        } else {
            tfContent.text = nil
        }
    }
}

// MARK: - extension: UIPickerViewDelegate, UIPickerViewDataSource
extension SelectorFormItemTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listItems[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.selectorFormItem(self, didSelectIndex: row, in: listItems)
        isValid = true
        if listItems.count > row {
            tfContent.text = listItems[row]
        }

    }
}
