//
//  LogoutUseCase.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 8/23/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol LogoutUseCase {
  typealias LogoutCompletionHandler = (Result<Void, Error>) -> Void
  
  func logout(completionHandler: @escaping LogoutCompletionHandler)
}

class LogoutUseCaseImpl: LogoutUseCase {
  
  private let gateway: AuthGateway
  
  init(gateway: AuthGateway) {
    self.gateway = gateway
  }
  
  func logout(completionHandler: @escaping LogoutCompletionHandler) {
    gateway.logout(complationHandler: completionHandler)
  }
}
