//
//  NSObject+Extension.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/11/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

extension NSObject {
    
    var theClassName: String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }
    
    class func getTheClassName() -> String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
