//
//  ButtonRound.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/11/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit

open class ButtonRound: UIButton {
    
    @IBInspectable var minimumScaleFactor: CGFloat = 0.5 {
        didSet {
            self.titleLabel?.minimumScaleFactor = minimumScaleFactor
        }
    }
    
    @IBInspectable var adjustsFontSize: Bool = false {
        didSet {
            self.titleLabel?.adjustsFontSizeToFitWidth = adjustsFontSize
        }
    }
    
    @IBInspectable open var roundRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = roundRadius
        }
    }
    
    @IBInspectable open var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable open var borderColor: UIColor? {
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
