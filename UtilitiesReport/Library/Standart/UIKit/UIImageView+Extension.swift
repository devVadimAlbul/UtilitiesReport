//
//  UIImageView+Extension.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/25/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit.UIImageView

extension UIImageView {
    func getImageFrame(in rect: CGRect) -> CGRect {
        guard let imageSize = self.image?.size else { return CGRect.zero }
        let imageRatio = imageSize.width / imageSize.height
        let imageViewRatio = rect.width / rect.height
        if imageRatio < imageViewRatio {
            let scaleFactor = rect.height / imageSize.height
            let width = imageSize.width * scaleFactor
            let topLeftX = (rect.width - width) * 0.5
            return CGRect(x: topLeftX, y: 0, width: width, height: rect.height)
        } else {
            let scalFactor = rect.width / imageSize.width
            let height = imageSize.height * scalFactor
            let topLeftY = (rect.height - height) * 0.5
            return CGRect(x: 0, y: topLeftY, width: rect.width, height: height)
        }
    }
}
