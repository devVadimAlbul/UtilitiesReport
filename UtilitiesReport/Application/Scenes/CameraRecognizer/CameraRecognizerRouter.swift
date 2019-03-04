//
//  CameraRecognizerRouter.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/26/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol CameraRecognizerRouter {
    
}

class CameraRecognizerRouterImpl: CameraRecognizerRouter {
 
    fileprivate weak var viewController: CameraRecognizerViewController?
    
    init(viewController: CameraRecognizerViewController) {
        self.viewController = viewController
    }
}
