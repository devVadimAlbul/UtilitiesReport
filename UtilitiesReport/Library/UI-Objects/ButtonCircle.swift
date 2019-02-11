//
//  ButtonCircle.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/11/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit

class ButtonCircle: UIButton {
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeCircle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeCircle()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeCircle()
    }
    
    private func makeCircle() {
        self.layer.cornerRadius = frame.size.height/2
        self.clipsToBounds = true
    }
}
