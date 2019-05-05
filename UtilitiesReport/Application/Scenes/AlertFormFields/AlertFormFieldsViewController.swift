//
//  AlertFormFieldsViewController.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/10/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import UIKit

protocol AlertFormFieldsView: AnyObject {
    var configurator: AlertFormFieldsConfigurator! { get }
    var props: AlertFormFieldsViewController.Props { get set }
}

class AlertFormFieldsViewController: BasicViewController, AlertFormFieldsView {
    
    // MARK: IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSave: ButtonRound!
    @IBOutlet weak var contentStatckView: UIStackView!
    
    // MARK: property
    var configurator: AlertFormFieldsConfigurator!
    var alertPresenter: AlertFormFieldsPresenter? {
        return presenter as? AlertFormFieldsPresenter
    }
    var props: AlertFormFieldsViewController.Props = .initial {
        didSet {
            render(props: props)
        }
    }
    
    // MARK: - life-cycle
    override func viewDidLoad() {
        configurator?.configure(viewController: self)
        super.viewDidLoad()
    }

    // MARK: update UI
    private func render(props: Props) {
        lblTitle.text = props.title
        btnSave.setTitle(props.buttonSaveTitle, for: .normal)
        updateContentStack(props: props)
        view.setNeedsLayout()
        switch props.state {
        case .edit:
            ProgressHUD.dismiss()
        case .falied(error: let error):
            ProgressHUD.dismiss()
            showErrorAlert(message: error)
        case .loading:
            ProgressHUD.show(message: "Loading...")
        case .success:
            ProgressHUD.success("Save success!", withDelay: 0.3)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func updateContentStack(props: Props) {
        if contentStatckView.arrangedSubviews.isEmpty {
            props.fields.forEach {
                let field = getTextField(item: $0)
                contentStatckView.addArrangedSubview(field)
            }
        } else {
            props.fields.enumerated().forEach { (index, item) in
                if contentStatckView.arrangedSubviews.count > index {
                    let viewArr = contentStatckView.arrangedSubviews[index]
                    if let field = viewArr as? UITextField {
                        updateContentTextField(in: field, with: item)
                    } else {
                        viewArr.removeFromSuperview()
                        let field = getTextField(item: item)
                        contentStatckView.addArrangedSubview(field)
                    }
                } else {
                    let field = getTextField(item: item)
                    contentStatckView.addArrangedSubview(field)
                }
            }
        }
    }
    
    private func updateContentTextField(in textField: UITextField, with item: Props.ItemField) {
        textField.placeholder = item.placeholder
        updateTextIfNeeded(in: textField, with: item, using: \.value)
    }
    
    private func updateTextIfNeeded<T>(in textField: UITextField,
                                       with source: T,
                                       using keyPath: KeyPath<T, String?>) {
        guard !textField.isFirstResponder else { return }
        textField.text = source[keyPath: keyPath]
    }
    
    private func getTextField(item: Props.ItemField) -> UITextField {
        let textField = UITextField()
        textField.placeholder = item.placeholder
        textField.text = item.value
        textField.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
        textField.borderStyle = .none
        textField.backgroundColor = .lightGray
        textField.textColor = .white
        textField.tintColor = .white
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 45))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.placeholderColor(.white)
        textField.layer.cornerRadius = 8
        textField.clipsToBounds = true
        textField.font = .preferredFont(forTextStyle: .body)
        textField.adjustsFontForContentSizeCategory = true
        textField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        return textField
    }
    
    @objc private func valueChanged(_ sender: UITextField) {
        if let index = contentStatckView.arrangedSubviews.firstIndex(where: {$0 == sender}) {
            if props.fields.count > index {
                props.fields[index].change.perform(with: sender.text)
            }
        }
    }
    
    // MARK: IBAction
    @IBAction func clickedControlView(_ sender: UIControl) {
        props.actionCancel.perform()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickedSaveButton(_ sender: UIButton) {
        props.actionSave.perform()
    }
}

extension AlertFormFieldsViewController {
    
    static let modalTransiton = ModalScaleTransiton()
    
    class func pressentAlertForm(by model: AlertFormModel,
                                 on viewController: UIViewController?,
                                 animated: Bool = true,
                                 transition: UIViewControllerTransitioningDelegate = modalTransiton,
                                 cancelHandler: @escaping () -> Void = {},
                                 saveHandler: @escaping (AlertFormModel) -> Void) {
        guard let viewController = viewController else { return }
        let configurator = AlertFormFieldsConfiguratorImpl(model: model,
                                                           saveCommand: CommandWith(action: saveHandler),
                                                           cancelCommand: Command(action: cancelHandler))
        let modal = AlertFormFieldsViewController()
        modal.configurator = configurator
        modal.modalPresentationStyle = .overCurrentContext
        modal.transitioningDelegate = transition
        
        viewController.present(modal, animated: true, completion: nil)
    }
}
