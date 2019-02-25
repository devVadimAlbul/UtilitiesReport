//
//  TextRecognizerImagePresenter.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/23/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit.UIImage
import Firebase

protocol TextRecognizerImagePresenter: PresenterProtocol {
    var router: TextRecognizerImageRouter { get }
    func textRecognize(image: UIImage)
}

class TextRecognizerImagePresenterImpl: TextRecognizerImagePresenter {
    
    var router: TextRecognizerImageRouter
    fileprivate weak var viewTextRecognizer: TextRecognizerImageView?
    fileprivate var textDetector: TextDetector
    
    init(view: TextRecognizerImageView, router: TextRecognizerImageRouter,
         textDetector: TextDetector) {
        self.router = router
        self.viewTextRecognizer = view
        self.textDetector = textDetector
    }
    
    func viewDidLoad() {
        viewTextRecognizer?.displayPageTitle("Text Recognizing")
    }
    
    func textRecognize(image: UIImage) {
        textDetector.recognize(image) { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success(let content):
                print(content)
//                for (indexBlock, block) in content.blocks.enumerated() {
//                    self.viewTextRecognizer?.addRectangleView("item_\(indexBlock)", in: block.frame, color: .purple)
//                    for (lineIndex, line) in block.lines.enumerated() {
//                        self.viewTextRecognizer?.addRectangleView("item_\(indexBlock)_\(lineIndex)",
//                            in: line.frame, color: .orange)
//                        for (elementIndex, element) in line.elements.enumerated() {
//                            self.viewTextRecognizer?.addRectangleView("item_\(indexBlock)_\(lineIndex)_\(elementIndex)",
//                                in: element.frame, color: .green)
//                        }
//                    }
//                }
            case .failure(let error):
                self.viewTextRecognizer?.displayError(message: error.localizedDescription)
            }
        }
    }
}
