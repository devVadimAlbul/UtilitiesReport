//
//  LoacalStoragePersistence.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/13/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol LoacalStoragePersistence {
    associatedtype EntityType
    associatedtype InputParamsType
    
    typealias FetchEntitiesCompletionHandler = (_ books: Result<[EntityType]>) -> Void
    typealias AddEntityCompletionHandler = (_ books: Result<EntityType>) -> Void
    typealias DeleteEntityCompletionHandler = (_ books: Result<Void>) -> Void
    
    func getEntity(by identifier: String) -> Result<EntityType?>
    func fetchBooks(completionHandler: @escaping FetchEntitiesCompletionHandler)
    func add(parameters: InputParamsType, completionHandler: @escaping AddEntityCompletionHandler)
    func delete(entity: EntityType, completionHandler: @escaping DeleteEntityCompletionHandler)
}
