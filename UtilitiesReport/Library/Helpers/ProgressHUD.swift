//
//  ProgressHUB.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/11/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import SVProgressHUD


class ProgressHUD {
    
    class func configure() {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.black)
    }

    
    class func show(mesage: String? = nil) {
        SVProgressHUD.show(withStatus: mesage)
    }
    
    class func success(_ message: String = "Success!", withDelay: TimeInterval = 0.3) {
        SVProgressHUD.showSuccess(withStatus: message)
        SVProgressHUD.dismiss(withDelay: withDelay)
    }
    
    class func dismiss() {
        SVProgressHUD.dismiss()
    }
    
    class func showProgress(_ progress: Double, status: String? = nil) {
        SVProgressHUD.showProgress(Float(progress), status: "Loading...")
    }
    
    class func error(_ message: String) {
        SVProgressHUD.showError(withStatus: message)
    }
}
