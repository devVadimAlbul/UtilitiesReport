//
//  SelectItemCounterTableViewCell.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 5/4/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import UIKit

protocol SelectItemCounterDelegate: AnyObject {
    func selectItemCounter(_ view: SelectItemCounterViewCell, didSelectIndex index: Int, in list: [String])
}

protocol SelectItemCounterViewCell: BasicVeiwCellProtocol {
    func displayTitle(_ title: String)
    func displayValue(_ text: String?)
    func displayPlaceholder(_ placeholder: String?)
    func displayListItems(_ list: [String], selectedIndex: Int?)
    var delegate: SelectItemCounterDelegate? { get set }
    var identifier: String? { get set }
}

class SelectItemCounterTableViewCell: UITableViewCell, SelectItemCounterViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfValue: UITextField!
    
    // MARK: property
    var identifier: String?
    weak var delegate: SelectItemCounterDelegate?
    private var pickerView: UIPickerView = UIPickerView()
    private var listItems: [String] = []
    private var isValid: Bool = true {
        didSet {
            tfValue.layer.borderColor = isValid ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        tfValue.addImage(in: .right,
                   with: #imageLiteral(resourceName: "arrow-down"),
                   to: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)),
                   backgroundColor: .clear,
                   tintColor: .gray)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tfValue.inputView = pickerView
        pickerView.delegate = self
        pickerView.backgroundColor = .white
        pickerView.dataSource = self
    }
    
    func displayTitle(_ title: String) {
        self.lblTitle.text = title
    }
    
    func displayValue(_ text: String?) {
        tfValue.text = text
    }
    
    func displayPlaceholder(_ placeholder: String?) {
        tfValue.placeholder = placeholder
    }
    
    func displayListItems(_ list: [String], selectedIndex: Int?) {
        self.listItems = listItems
        pickerView.reloadAllComponents()
        if let selectedIndex = selectedIndex, list.count > selectedIndex {
            pickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
            tfValue.text = listItems[selectedIndex]
        } else {
            tfValue.text = nil
        }
    }
}


// MARK: - extension: UIPickerViewDelegate, UIPickerViewDataSource
extension SelectItemCounterTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        delegate?.selectItemCounter(self, didSelectIndex: row, in: listItems)
        isValid = true
        if listItems.count > row {
            tfValue.text = listItems[row]
        }
    }
}
