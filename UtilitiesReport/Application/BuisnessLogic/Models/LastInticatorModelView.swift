//
//  LastInticatorModelView.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/13/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit

struct LastInticatorModelView {
    var name: String?
    var months: String?
    var value: String?
    
    init(name: String?, months: String?, value: String?) {
        self.name = name
        self.months = months
        self.value = value
    }
}
