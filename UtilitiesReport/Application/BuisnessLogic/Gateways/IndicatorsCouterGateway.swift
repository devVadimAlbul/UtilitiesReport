//
//  InticatorsCouterGateway.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/14/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol IndicatorsCouterGateway {
    typealias FetchEntitiesCompletionHandler = (_ result: Result<[IndicatorsCounter]>) -> Void
    typealias AddEntityCompletionHandler = (_ result: Result<IndicatorsCounter>) -> Void
    typealias DeleteEntityCompletionHandler = (_ result: Result<Void>) -> Void
    
    func fetch(by predicate: NSPredicate, completionHandler: @escaping FetchEntitiesCompletionHandler)
    func delete(entity: IndicatorsCounter, completionHandler: @escaping DeleteEntityCompletionHandler)
    func deleteAll(by predicate: NSPredicate, completionHandler: @escaping DeleteEntityCompletionHandler)
    func save(entity: IndicatorsCounter, completionHandler: @escaping AddEntityCompletionHandler)
    func add(entity: IndicatorsCounter, toUserCompanyID identifier: String,
             completionHandler: @escaping AddEntityCompletionHandler)
}
