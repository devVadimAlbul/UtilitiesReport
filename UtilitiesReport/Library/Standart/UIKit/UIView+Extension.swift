//
//  UIView+Extension.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/11/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit.UIView

private var kAssociationKeyViewIdentifier = "kAssociationKeyViewIdentifier"

extension UIView {
    
    class func nib() -> UINib? {
        return UINib(nibName: self.getTheClassName(), bundle: Bundle(for: self))
    }
    
    class var identifier: String {
        return  "\(self.self)"
    }
    
    var viewIdentifier: String? {
        get {
            return objc_getAssociatedObject(self, &kAssociationKeyViewIdentifier) as? String
        }
        set(newField) {
            objc_setAssociatedObject(self, &kAssociationKeyViewIdentifier, newField, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
