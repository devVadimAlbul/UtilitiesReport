//
//  UIView+Extension.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/11/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit.UIView

extension UIView {
    
    class func nib() -> UINib? {
        return UINib(nibName: self.getTheClassName(), bundle: Bundle(for: self))
    }
    
    class var identifier: String {
        return  "\(self.self)"
    }
}
