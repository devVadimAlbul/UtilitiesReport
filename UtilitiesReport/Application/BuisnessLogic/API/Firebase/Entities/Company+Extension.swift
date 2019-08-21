//
//  Company+Extension.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 8/12/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

extension Company {
  
  init(identifier: String, data: [String: Any]) {
    self.identifier = identifier
    self.name = (data["name"] as? String) ?? ""
    self.isNeedCounter = (data["is_need_counter"] as? Bool) ?? false
    self.city = (data["city"] as? String) ?? ""
    let strType = (data["type"] as? String) ?? ""
    self.type = CompanyType(rawValue: strType) ?? .default
    self.siteURLString = data["site_url"] as? String
  }
}
//
//extension Sequence where Iterator.Element == QueryDocumentSnapshot {
//  
//  func toDomains() -> [Company] {
//    return self.map({Company(identifier: $0.documentID, data: $0.data())})
//  }
//}
