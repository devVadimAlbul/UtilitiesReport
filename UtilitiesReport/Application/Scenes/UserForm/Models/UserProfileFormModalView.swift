//
//  UserProfileModalView.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/11/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit

struct UserProfileFormModalView {
    var items: [FormItemModelView]
}

struct FormItemModelView {
    var identifier: String
    var title: String?
    var placeholder: String?
    var value: String?
    var warningMessage: String?
    var isOptional: Bool
    var keyboardType: UIKeyboardType
}
