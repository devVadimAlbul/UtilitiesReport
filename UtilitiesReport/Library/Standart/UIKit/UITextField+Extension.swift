//
//  UITextField+Extension.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/11/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import UIKit.UITextField

private var kAssociationKeyNextField = "kAssociationKeyNextField"

extension UITextField {
    
    @IBOutlet var nextField: UITextField? {
        get {
            return objc_getAssociatedObject(self, &kAssociationKeyNextField) as? UITextField
        }
        set(newField) {
            objc_setAssociatedObject(self, &kAssociationKeyNextField, newField, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    enum Direction {
        case left
        case right
    }
    
    func addImage(in direction: Direction, with image: UIImage,
                  to rect: CGRect, backgroundColor: UIColor, tintColor: UIColor) {
        let view = UIView(frame: rect)
        view.backgroundColor = backgroundColor
        view.isUserInteractionEnabled = false
        
        let imageView = UIImageView(frame: rect)
        imageView.contentMode = .scaleAspectFit
        imageView.image = image.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = tintColor
        
        view.addSubview(imageView)
        
        switch direction {
        case .left:
            self.leftViewMode = .always
            self.leftView = view
        case .right:
            self.rightViewMode = .always
            self.rightView = view
        }
    }
    
    func placeholderColor(_ color: UIColor) {
        if let placeholderText = self.placeholder {
            self.attributedPlaceholder = NSAttributedString(string: placeholderText,
                                                            attributes: [.foregroundColor: color])
        }
    }
}
