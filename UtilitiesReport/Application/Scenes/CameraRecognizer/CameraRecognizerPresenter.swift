//
//  CameraRecognizerPresenter.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/26/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation


protocol CameraRecognizerPresenter: PresenterProtocol {
    var router: CameraRecognizerRouter { get set }
}

class CameraRecognizerPresenterImpl: CameraRecognizerPresenter {
    
    var router: CameraRecognizerRouter
    fileprivate weak var viewCamera: CameraRecognizerView?
    
    init(view: CameraRecognizerView, router: CameraRecognizerRouter) {
        self.viewCamera = view
        self.router = router
    }
    
    // MARK: presenter methods
    func viewDidLoad() {
        
    }
}
