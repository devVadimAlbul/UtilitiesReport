//
//  TextRecognizerImageRouter.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/23/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol TextRecognizerImageRouter {
    
}

class TextRecognizerImageRouterImpl: TextRecognizerImageRouter {
    
    fileprivate weak var viewController: TextRecognizerImageViewController?
    
    init(viewController: TextRecognizerImageViewController) {
        self.viewController = viewController
    }
    
 
}
