//
//  TemplateContextUseCase.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/30/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol GenerateTemplateUseCase {
    func generate(with  indicators: [IndicatorsCounter],
                  by company: UserUtilitiesCompany,
                  template: String, completionHandler: @escaping (Result<String, Error>) -> Void)
}

class GenerateTemplateUseCaseImpl: GenerateTemplateUseCase {
    
    private var loadUserProfile: LoadUserProfileUseCase
    private var templateParser: TemplateParser
    
    init(loadUserProfile: LoadUserProfileUseCase, templateParser: TemplateParser) {
        self.loadUserProfile = loadUserProfile
        self.templateParser = templateParser
    }
    
    func generate(with  indicators: [IndicatorsCounter],
                  by company: UserUtilitiesCompany,
                  template: String,
                  completionHandler: @escaping (Result<String, Error>) -> Void) {
        loadUserProfile.load { (result) in
            switch result {
            case let .success(user):
                let context = TemplateContext(company: company, user: user, indicators: indicators)
                self.render(context: context, template: template, completionHandler: completionHandler)
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
    
    private func render(context: TemplateContext, template: String,
                        completionHandler: @escaping (Result<String, Error>) -> Void) {
        templateParser.render(template: template, context: context.context, completionHandler: completionHandler)
    }
    
    class var `default`: GenerateTemplateUseCase {
        let userProfileGateway = UserProfileGatewayImpl(api: FirebaseUserProfileGatewayImpl(),
                                                        storage: UserProfileLocalStorageGatewayImpl())
        let loadUseCase = LoadUserProfileUseCaseImpl(gateway: userProfileGateway)
        let parser = TemplateParserImpl()
        return GenerateTemplateUseCaseImpl(loadUserProfile: loadUseCase, templateParser: parser)
    }
}
