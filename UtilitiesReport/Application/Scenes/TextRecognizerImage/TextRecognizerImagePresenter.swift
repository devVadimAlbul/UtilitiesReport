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
    func saveRecognizedText()
}

class TextRecognizerImagePresenterImpl: TextRecognizerImagePresenter {
    
    var router: TextRecognizerImageRouter
    fileprivate weak var viewTextRecognizer: TextRecognizerImageView?
    fileprivate var textDetector: TextDetector
    private var recognizedText: String?
    
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
                print(content.text)
                let text = content.text.removeWhiteSpace()
                self.recognizedText = text
                self.viewTextRecognizer?.displayRecognizeTextSuccess(text)
            case .failure(let error):
                self.viewTextRecognizer?.displayRecognizeTextWarring(error.localizedDescription)
            }
        }
    }
    
    func saveRecognizedText() {
        if let text = self.recognizedText {
            self.viewTextRecognizer?.displaySuccess(text)
        } else {
            self.viewTextRecognizer?.displayError(message: URError.textNotRecognized.localizedDescription)
        }
    }
}
