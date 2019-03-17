//
//  CameraRecognizerConfigurator.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/26/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol CameraRecognizerConfigurator {
    func configure(viewController: CameraRecognizerViewController)
}

class CameraRecognizerConfiguratorImpl: CameraRecognizerConfigurator {
    
    func configure(viewController: CameraRecognizerViewController) {
        let router = CameraRecognizerRouterImpl(viewController: viewController)
        let presenter = CameraRecognizerPresenterImpl(view: viewController, router: router)
        
        viewController.presenter = presenter
    }
}
