//
//  UIImage+Extension.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/25/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit.UIImage

extension UIImage {
    
    func cropped(boundingBox: CGRect) -> UIImage? {
        guard let cgImage = self.cgImage?.cropping(to: boundingBox) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
}
