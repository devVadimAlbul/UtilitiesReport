//
//  String+Extension.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/11/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

extension String {
    
    func removeWhiteSpace() -> String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
}
