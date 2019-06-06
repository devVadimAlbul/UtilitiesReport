//
//  LoadUserCompaniesUseCase.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/2/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol LoadUserCompaniesUseCase {    
    func loadList(_ completionHandler: @escaping (Result<[UserUtilitiesCompany], Error>) -> Void)
    func loadCompany(by identifier: String,
                     completionHandler: @escaping (_ result: Result<UserUtilitiesCompany, Error>) -> Void)
  
}

class LoadUserCompaniesUseCaseImpl: LoadUserCompaniesUseCase {
    
    private let gateway: UserUtilitesCompanyGateway
    
    init(gateway: UserUtilitesCompanyGateway) {
        self.gateway = gateway
    }
    
    func loadList(_ completionHandler: @escaping (Result<[UserUtilitiesCompany], Error>) -> Void) {
        gateway.fetch(completionHandler: completionHandler)
    }
    
    func loadCompany(by identifier: String,
                     completionHandler: @escaping (_ result: Result<UserUtilitiesCompany, Error>) -> Void) {
        gateway.load(by: identifier, completionHandler: completionHandler)
    }
}
