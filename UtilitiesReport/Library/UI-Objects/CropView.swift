//
//  CropView.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/25/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit

class CropView: UIView {
    
    private let fillLayer = CAShapeLayer()
    var areaCropFrame: CGRect = .zero
    @IBInspectable var areaPadding: CGFloat = 30
    @IBInspectable var areaRatio: CGFloat = 130/700
    @IBInspectable var areaRadius: CGFloat = 5
    @IBInspectable var areaColor: UIColor = .white
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawCropArea()
    }
    
    private func drawCropArea() {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.bounds.size.width,
                                                    height: self.bounds.size.height), cornerRadius: 0)
        let width = self.bounds.size.width - (areaPadding * 2)
        let areaSize = CGSize(width: width, height: width * areaRatio)
        areaCropFrame = CGRect(x: self.bounds.midX - (areaSize.width/2),
                               y: self.bounds.midY - (areaSize.height/2),
                               width: areaSize.width,
                               height: areaSize.height)
        let cropPath = UIBezierPath(roundedRect: areaCropFrame, cornerRadius: areaRadius)
        path.append(cropPath)
        
        fillLayer.removeFromSuperlayer()
        fillLayer.path = path.cgPath
        fillLayer.fillRule = .evenOdd
        fillLayer.fillColor = UIColor.white.cgColor
        fillLayer.opacity = 0.5
        
        layer.addSublayer(fillLayer)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
}
