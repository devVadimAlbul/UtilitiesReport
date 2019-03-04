//
//  Gateways.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/27/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol UserProfileGateway {
    typealias FetchUsersProfileCompletionHandler = (_ result: Result<[UserProfile]>) -> Void
    typealias AddUserProfileCompletionHandler = (_ result: Result<UserProfile>) -> Void
    typealias DeleteUserProfileCompletionHandler = (_ result: Result<Void>) -> Void
    
    func getEntity(by identifier: String) -> Result<UserProfile?>
    func fetch(completionHandler: @escaping FetchUsersProfileCompletionHandler)
    func add(parameters: UserProfile, completionHandler: @escaping AddUserProfileCompletionHandler)
    func delete(entity: UserProfile, completionHandler: @escaping DeleteUserProfileCompletionHandler)
}
