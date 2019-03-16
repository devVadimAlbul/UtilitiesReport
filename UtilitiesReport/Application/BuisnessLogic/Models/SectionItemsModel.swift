//
//  SectionItemsModel.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/16/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

struct SectionItemsModel<T> {
    var title: String?
    var items: [T] = []
    
    init(title: String?, items: [T]) {
        self.title = title
        self.items = items
    }
}
