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
    
    public func navigationPresent(_ viewController: UIViewController, animated: Bool = true, isNeedClose: Bool = true) {
        let navigation = VCLoader<UINavigationController>.loadInitial(storyboardId: .navigation)
        navigation.pushViewController(viewController, animated: false)
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
}
