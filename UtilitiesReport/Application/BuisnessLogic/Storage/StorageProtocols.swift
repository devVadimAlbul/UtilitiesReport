//
//  StoringProvidable.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/10/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol StoringProvidable {
    func saveValue(_ value: String?, forKey key: String) throws
    func saveData(_ data: Data?, forKey key: String) throws
    func getValue(forKey key: String) throws -> String?
    func getData(forKey key: String) throws -> Data?
}
