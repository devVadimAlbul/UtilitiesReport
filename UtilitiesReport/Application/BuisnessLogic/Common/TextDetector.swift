//
//  TextDetector.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/17/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit.UIImage
import SwiftOCR
//import TesseractOCR

protocol TextDetector: class {
    func recognize(_ image: UIImage, completion: @escaping (Result<String>) -> Void)
}

class TextDetectorOCRImpl: TextDetector {
    
    let instance = SwiftOCR()

    func recognize(_ image: UIImage, completion: @escaping (Result<String>) -> Void) {
        instance.recognize(image) { (resultText) in
            completion(.success(resultText))
        }
    }
}
