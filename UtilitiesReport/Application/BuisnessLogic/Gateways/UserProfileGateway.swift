//
//  Gateways.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/27/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol UserProfileGateway {
//    typealias FetchUsersProfileCompletionHandler = (_ result: Result<[UserProfile]>) -> Void
    typealias AddUserProfileCompletionHandler = (_ result: Result<UserProfile, Error>) -> Void
    typealias DeleteUserProfileCompletionHandler = (_ result: Result<Void, Error>) -> Void
    typealias LoadUserProfileCompletionHandler = (_ result: Result<UserProfile, Error>) -> Void
    
//    func getEntity(by identifier: String) -> Result<UserProfile?>
//    func fetch(completionHandler: @escaping FetchUsersProfileCompletionHandler)
    func loadEntity(completionHandler: @escaping LoadUserProfileCompletionHandler)
    func add(parameters: UserProfile, completionHandler: @escaping AddUserProfileCompletionHandler)
    func delete(entity: UserProfile, completionHandler: @escaping DeleteUserProfileCompletionHandler)
}
