//
//  Models.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/11/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit

struct AlertModelView {
    let title: String
    let message: String?
    var actions: [AlertActionModelView]
}

struct AlertActionModelView {
    let title: String?
    var action: CommandWith<UIAlertAction>?
}
