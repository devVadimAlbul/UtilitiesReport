//
//  LoadUserComapanies.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/2/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol LoadUserComapaniesUseCase {    
    func loadList(_ completionHandler: @escaping (Result<[UserUtilitiesCompany]>) -> Void)
}

class LoadUserComapaniesUseCaseImpl: LoadUserComapaniesUseCase {
    
    private let gateway: UserUtilitesCompanyGateway
    
    init(gateway: UserUtilitesCompanyGateway) {
        self.gateway = gateway
    }
    
    func loadList(_ completionHandler: @escaping (Result<[UserUtilitiesCompany]>) -> Void) {
        gateway.fetch(completionHandler: completionHandler)
    }
}
