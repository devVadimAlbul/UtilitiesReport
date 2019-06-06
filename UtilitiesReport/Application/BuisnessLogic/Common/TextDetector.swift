//
//  TextDetector.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/17/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit.UIImage
import Firebase

protocol TextDetector: class {
    func recognize(_ image: UIImage, completion: @escaping (Result<VisionText, Error>) -> Void)
}

class TextDetectorFirebaseImpl: TextDetector {
    
    let vision = Vision.vision()
    
    func recognize(_ image: UIImage, completion: @escaping (Result<VisionText, Error>) -> Void) {
        let textRecognizer = vision.onDeviceTextRecognizer()
        let visionImage = VisionImage(image: image)
        textRecognizer.process(visionImage) { result, error in
            guard error == nil, let result = result else {
                completion(.failure(error ?? URError.textNotRecognized))
                return
            }
            completion(.success(result))
        }
    }
}
