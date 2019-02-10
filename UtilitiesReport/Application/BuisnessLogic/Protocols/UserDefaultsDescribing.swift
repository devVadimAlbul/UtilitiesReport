//
//  UserDefaultsDescribing.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/10/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol UserDefaultsDescribing: class {
    func set(_ value: Any?, forKey defaultName: String)
    func value(forKey key: String) -> Any?
    func synchronize() -> Bool
}
