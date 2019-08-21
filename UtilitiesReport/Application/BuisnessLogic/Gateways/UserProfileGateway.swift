//
//  Gateways.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/27/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol UserProfileGateway {
    typealias AddUserProfileCompletionHandler = (_ result: Result<UserProfile, Error>) -> Void
    typealias DeleteUserProfileCompletionHandler = (_ result: Result<Void, Error>) -> Void
    typealias LoadUserProfileCompletionHandler = (_ result: Result<UserProfile, Error>) -> Void
  
    func load(completionHandler: @escaping LoadUserProfileCompletionHandler)
    func save(parameters: UserProfile, completionHandler: @escaping AddUserProfileCompletionHandler)
    func delete(entity: UserProfile, completionHandler: @escaping DeleteUserProfileCompletionHandler)
}

class UserProfileGatewayImpl: UserProfileGateway {
  
  private var api: ApiUserProfileGateway
  private var storage: UserProfileLocalStorageGateway
  
  init(api: ApiUserProfileGateway, storage: UserProfileLocalStorageGateway) {
    self.api = api
    self.storage = storage
  }

  func load(completionHandler: @escaping LoadUserProfileCompletionHandler) {
    api.load { [weak self] (result) in
      self?.handleLoadApiResult(result, completionHandler: completionHandler)
    }
  }
  
  func save(parameters: UserProfile, completionHandler: @escaping AddUserProfileCompletionHandler) {
    api.save(parameters: parameters) { [weak self] (result) in
      guard let `self` = self else { return }
      switch result {
      case .success(let user):
        self.storage.save(parameters: user, completionHandler: {_ in })
        completionHandler(.success(user))
      case .failure(let error):
        completionHandler(.failure(error))
      }
    }
  }
  
  func delete(entity: UserProfile, completionHandler: @escaping DeleteUserProfileCompletionHandler) {
    api.delete(entity: entity) { [weak self] (_) in
      guard let `self` = self else { return }
      self.storage.delete(entity: entity, completionHandler: completionHandler)
    }
  }
  
  private func handleLoadApiResult(_ result: Result<UserProfile, Error>,
                                   completionHandler: @escaping LoadUserProfileCompletionHandler) {
    switch result {
    case .success(let user):
      storage.save(parameters: user, completionHandler: {_ in })
      completionHandler(.success(user))
    case .failure(let error):
      storage.deleteAll(completionHandler: {_ in })
      completionHandler(.failure(error))
    }
  }
}
