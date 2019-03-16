//
//  FindIndicatorsCounterUseCase.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/16/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol FindIndicatorsCounterUseCase {
    func findListIndiactors(companyId: String,
                            _ completionHandler: @escaping (Result<(String, [IndicatorsCounter])>) -> Void)
}

class FindIndicatorsCounterUseCaseImpl: FindIndicatorsCounterUseCase {
    
    private var manager: RealmManagerProtocol
    
    init(manager: RealmManagerProtocol) {
        self.manager = manager
    }
    
    func findListIndiactors(companyId: String,
                            _ completionHandler: @escaping (Result<(String, [IndicatorsCounter])>) -> Void) {
        
        if let company = manager.getEntity(withType: RealmUserUtilitiesCompany.self, for: companyId) {
            let indicators: [IndicatorsCounter] = company.indicators.map({$0.indicatorsModel})
            let name = company.company?.name ?? company.accountNumber
            completionHandler(.success((name, indicators)))
        } else {
            completionHandler(.failure(URError.userCompanyNotFound))
        }
    }
}
