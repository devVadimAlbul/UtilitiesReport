//
//  TextRecognizerImageConfigurator.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/23/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit.UIImage

protocol TextRecognizerImageConfigurator {
    func configure(viewController: TextRecognizerImageViewController)
    var rectangleViewCornerRadius: CGFloat { get }
    var rectangleViewAlpha: CGFloat { get }
}

class TextRecognizerImageConfiguratorImpl: TextRecognizerImageConfigurator {
    
    private var contentImage: UIImage
    var rectangleViewCornerRadius: CGFloat = 10.0
    var rectangleViewAlpha: CGFloat = 0.3
    
    init(image: UIImage) {
        self.contentImage = image
    }
    
    func configure(viewController: TextRecognizerImageViewController) {
        let router = TextRecognizerImageRouterImpl(viewController: viewController)
        let detector = TextDetectorFirebaseImpl()
        let presenter = TextRecognizerImagePresenterImpl(view: viewController, router: router,
                                                         textDetector: detector)
        viewController.contentImage = contentImage
        viewController.presenter = presenter
    }
}
