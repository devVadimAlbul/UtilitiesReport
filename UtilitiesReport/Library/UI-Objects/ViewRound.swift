//
//  ViewRound.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/12/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit.UIView
import UIKit.UIColor

class ViewRound: UIView {
    
    @IBInspectable var roundRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = roundRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.clipsToBounds = true
    }
}
