//
//  UINavigationController+Extension.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/21/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit.UINavigationController

extension UINavigationController {
    
    func backToViewController(_ vcClass: Swift.AnyClass) {
        if let vController = getViewControllerInStack(vcClass) {
            self.popToViewController(vController, animated: true)
        }
    }
    
    func getViewControllerInStack(_ vcClass: Swift.AnyClass) -> UIViewController? {
        for controller in self.viewControllers.reversed() {
            if controller.isKind(of: vcClass) {
                return controller
            }
        }
        return nil
    }
}
