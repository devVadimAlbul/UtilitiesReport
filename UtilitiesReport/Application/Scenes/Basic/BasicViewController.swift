//
//  BasicViewController.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/9/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import UIKit

class BasicViewController: UIViewController {
    
    // MARK: property
    var presenter: PresenterProtocol!

    // MARK: life-cycle
    override func viewDidLoad() {
        loadViewIfNeeded()
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: updagte UI
    func updateConstraints(animated: Bool, with duration: TimeInterval = 0.25) {
        func actionComplite() {
            self.view.invalidateIntrinsicContentSize()
            self.view.layoutIfNeeded()
        }
        
        if animated {
            UIView.animate(withDuration: duration, animations: actionComplite)
        } else {
            actionComplite()
        }
    }
    
    // MARK: action
    @objc open func closeViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: present methods
    public func navigationPresent(_ viewController: UIViewController, animated: Bool = true, isNeedClose: Bool = true) {
        ProgressHUD.dismiss()
        let navigation = VCLoader<UINavigationController>.loadInitial(storyboardId: .navigation)
        navigation.viewControllers = [viewController]
        let closeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "close"), style: .done, target: self, action: #selector(closeViewController))
        present(navigation, animated: animated, completion: {
            if isNeedClose {
                viewController.navigationItem.setLeftBarButton(closeButton, animated: false)
            }
        })
    }
    
    // MARK: present alert view
    func showErrorAlert(title: String = "Error!", message: String, buttonText: String = "Cancel") {
        ProgressHUD.dismiss()
        let model = AlertModelView(title: title, message: message, actions: [
                AlertActionModelView(title: buttonText, action: nil)
            ])
        presentAlert(by: model)
    }
    
    func presentAlert(by model: AlertModelView) {
        ProgressHUD.dismiss()
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        
        model.actions.forEach {
            let action = UIAlertAction(title: $0.title, style: .default, handler: $0.action?.perform)
            alert.addAction(action)
        }
        present(alert, animated: true, completion: nil)
    }
    
    func presentActionSheet(by model: AlertModelView) {
        ProgressHUD.dismiss()
        let actionSheet = UIAlertController(title: model.title, message: model.message, preferredStyle: .actionSheet)
        
        model.actions.forEach {
            let action = UIAlertAction(title: $0.title, style: .default, handler: $0.action?.perform)
            actionSheet.addAction(action)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
}
