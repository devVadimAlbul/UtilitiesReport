//
//  FormIndicatorCounterViewController.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/16/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

protocol FormIndicatorCounterView: AnyObject {
    var props: FormIndicatorCounterViewController.Props { get set }
}

class FormIndicatorCounterViewController: BasicViewController, FormIndicatorCounterView {
    
    // MARK: IBOutlet
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var tfDate: UITextField!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var lblCounter: UILabel!
    @IBOutlet weak var tfCounter: UITextField!
    @IBOutlet weak var btnSave: ButtonRound!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet weak var counterStackView: UIStackView!
    @IBOutlet var pickerView: UIPickerView!
    
    // MARK: property
    var configurator: FormIndicatorCounterConfigurator!
    private var formPresenter: FormIndicatorCounterPresenter? {
        return presenter as? FormIndicatorCounterPresenter
    }
    var props: Props = .initial {
        didSet {
            render(props: props)
        }
    }

    // MARK: life-cycle
    override func viewDidLoad() {
        configurator.configure(viewController: self)
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        tfDate.inputView = datePicker
        tfDate.addCancelDoneOnKeyboardWithTarget(self,
                                                 cancelAction: #selector(actionTFDateCancel),
                                                 doneAction: #selector(actionTFDateDone))
        tfCounter.inputView = pickerView
        tfValue.addTarget(self, action: #selector(changedTFValue), for: .editingChanged)
        tfCounter.addImage(in: .right,
                           with: #imageLiteral(resourceName: "arrow-down"),
                           to: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)),
                           backgroundColor: .clear,
                           tintColor: .gray)
        
    }
    
    // MARK: update UI
    private func render(props: Props) {
        title = props.pageTitle
        btnSave.setTitle(props.buttonSaveTitle, for: .normal)
        lblDate.text = props.date.name
        updateContentTextField(in: tfDate, with: props.date)
        if !tfDate.isFirstResponder {
            datePicker.setDate(props.selectedDate, animated: false)
        }
        
        lblValue.text = props.indicator.name
        updateContentTextField(in: tfValue, with: props.indicator)
        
        lblCounter.text = props.counter.name
        updateContentTextField(in: tfCounter, with: props.counter)
        if let selected = props.selectedCounterItem, !tfCounter.isFirstResponder {
            pickerView.reloadAllComponents()
            pickerView.selectRow(selected.row, inComponent: selected.component, animated: false)
        }
        counterStackView.isHidden = !props.isNeedCounter
        
        view.setNeedsLayout()
        switch props.state {
        case .edit:
            ProgressHUD.dismiss()
        case .falied(error: let error):
            ProgressHUD.dismiss()
            showErrorAlert(message: error)
        case .loading:
            ProgressHUD.show(mesage: "Loading...")
        case .success:
            ProgressHUD.success("Save success!", withDelay: 0.3)
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func updateContentTextField<T>(in textField: UITextField, with item: Props.Field<T>) {
        textField.placeholder = item.placeholder
        updateTextIfNeeded(in: textField, with: item, using: \.value)
    }
    
    private func updateTextIfNeeded<T>(in textField: UITextField,
                                       with source: T,
                                       using keyPath: KeyPath<T, String?>) {
        guard !textField.isFirstResponder else { return }
        textField.text = source[keyPath: keyPath]
    }

    // MARK: target action
    @objc private func changedTFValue(_ sender: UITextField) {
        props.indicator.change.perform(with: sender.text)
    }
    
    @objc private func actionTFDateDone() {
        tfDate.resignFirstResponder()
        if let date = datePicker?.date {
            props.date.change.perform(with: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM yyyy"
            tfDate.text =  dateFormatter.string(from: date)
        }
    }
    
    @objc private func actionTFDateCancel () {
        tfDate.resignFirstResponder()
        datePicker.setDate(props.selectedDate, animated: false)
    }
    
    @IBAction func clickedBtnSave(_ sender: UIButton) {
        props.commandSave.perform()
    }
}


// MARK: - extension: UIPickerViewDelegate, UIPickerViewDataSource
extension FormIndicatorCounterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return formPresenter?.numberOfComponentsList() ?? 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return formPresenter?.numberOfRowsList(in: component) ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return formPresenter?.titleItemList(forRow: row, forComponent: component)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tfCounter.text = formPresenter?.titleItemList(forRow: row, forComponent: component)
        props.counter.change.perform(with: (row, component))
    }
}
