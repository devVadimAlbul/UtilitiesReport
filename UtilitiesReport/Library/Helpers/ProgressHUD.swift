//
//  ProgressHUB.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/11/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import KRProgressHUD


class ProgressHUD {
    
    class func configure() {
        let appearance = KRProgressHUD.appearance()
        appearance.style = .black
        appearance.maskType = .black
    }
    
    class func show(message: String? = nil) {
        if let message = message {
            KRProgressHUD.showMessage(message)
        } else {
            KRProgressHUD.show()
        }
    }
    
    class func success(_ message: String = "Success!", withDelay: TimeInterval = 0.3) {
        KRProgressHUD.showSuccess(withMessage: message)
        DispatchQueue.main.asyncAfter(deadline: .now()+withDelay) {
            KRProgressHUD.dismiss()
        }
    }
    
    class func dismiss() {
        DispatchQueue.main.async {
            KRProgressHUD.dismiss()
        }
    }
    
    class func error(_ message: String) {
        KRProgressHUD.showError(withMessage: message)
    }
}
