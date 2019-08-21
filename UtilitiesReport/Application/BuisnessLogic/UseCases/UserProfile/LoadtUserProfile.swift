//
//  GetUserProfile.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/11/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

typealias LoadUserProfileUseCaseCompletionHandler = (_ books: Result<UserProfile, Error>) -> Void

protocol LoadUserProfileUseCase {
    func load(completionHandler: @escaping LoadUserProfileUseCaseCompletionHandler)
}

class LoadUserProfileUseCaseImpl: LoadUserProfileUseCase {
    
    fileprivate let gateway: UserProfileGateway
    
    init(gateway: UserProfileGateway) {
        self.gateway = gateway
    }
    
    func load(completionHandler: @escaping LoadUserProfileUseCaseCompletionHandler) {
        gateway.load(completionHandler: completionHandler)
    }
}
