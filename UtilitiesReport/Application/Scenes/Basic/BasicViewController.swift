//
//  BasicViewController.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/9/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import UIKit

class BasicViewController: UIViewController {
    
    var presneter: PresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        presneter?.viewDidLoad()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    public func navigationPresent(_ viewController: UIViewController, animated: Bool = true, isNeedClose: Bool = true) {
        let navigation = VCLoader<UINavigationController>.loadInitial(storyboardId: .navigation)
        navigation.viewControllers = [viewController]
        let closeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "close"), style: .done, target: self, action: #selector(closeViewController))
        present(navigation, animated: animated, completion: {
            if isNeedClose {
                viewController.navigationItem.setLeftBarButton(closeButton, animated: false)
            }
        })
    }
    
    @objc open func closeViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showErrorAlert(title: String = "Error!", message: String, buttonText: String = "Cancel") {
        let model = AlertModelView(title: title, message: message, actions: [
                AlertActionModelView(title: buttonText, actionHandler: nil)
            ])
        presentAlert(by: model)
    }
    
    func presentAlert(by model: AlertModelView) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        
        model.actions.forEach {
            let action = UIAlertAction(title: $0.title, style: .default, handler: $0.actionHandler)
            alert.addAction(action)
        }
        present(alert, animated: true, completion: nil)
    }
}
