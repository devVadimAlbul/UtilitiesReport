//
//  ProgressHUB.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/11/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import KRProgressHUD
import NVActivityIndicatorView


class ProgressHUD {
    
    class func configure() {
//        let appearance = KRProgressHUD.appearance()
//        appearance.style = .black
//        appearance.maskType = .black
    }
    
    class func show(message: String? = nil) {
      //        if let message = message {
          let data = ActivityData(message: message,
                                  type: .ballClipRotateMultiple,
                                  color: .white,
                                  padding: 10,
                                  backgroundColor: UIColor.black.withAlphaComponent(0.6),
                                  textColor: .white)
          NVActivityIndicatorPresenter.sharedInstance.startAnimating(data)
//            KRProgressHUD.showMessage(message)
//        } else {
//            KRProgressHUD.show()
//        }
    }
    
    class func success(_ message: String = "Success!", withDelay: TimeInterval = 0.3) {
//        KRProgressHUD.showSuccess(withMessage: message)
//        DispatchQueue.main.asyncAfter(deadline: .now()+withDelay) {
//            KRProgressHUD.dismiss()
//        }
//      DispatchQueue.main.async {
        let data = ActivityData(message: message,
                                messageSpacing: 10,
                                type: .squareSpin,
                                color: .green,
                                padding: 10,
                                minimumDisplayTime: 1,
                                backgroundColor: UIColor.black.withAlphaComponent(0.6),
                                textColor: .green)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(data)
//      }
    }
    
    class func dismiss() {
        DispatchQueue.main.async {
          NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
//            KRProgressHUD.dismiss()
        }
    }
    
    class func error(_ message: String) {
      let data = ActivityData(message: message,
                              messageSpacing: 10,
                              type: .ballTrianglePath,
                              color: .red,
                              padding: 10,
                              minimumDisplayTime: 1,
                              backgroundColor: UIColor.black.withAlphaComponent(0.6),
                              textColor: .white)
      NVActivityIndicatorPresenter.sharedInstance.startAnimating(data)
//        KRProgressHUD.showError(withMessage: message)
    }
}
