//
//  FormationReportManager.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 4/6/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation


protocol FormationReportManager {
    func formation(with indicators: [IndicatorsCounter],
                   template: TemplateReport,
                   userCompany: UserUtilitiesCompany,
                   completionHandler: @escaping (Result<SendReportModel, Error>) -> Void)
}

class FormationReportManagerImpl: FormationReportManager {
    
    private var generateTemplate: GenerateTemplateUseCase
    private var downloadGateway: ApiDownloadTemplateGateway
    
    init(generateTemplate: GenerateTemplateUseCase = GenerateTemplateUseCaseImpl.default,
         downloadGateway: ApiDownloadTemplateGateway = ApiDownloadTemplateGatewayImpl.default) {
        self.generateTemplate = generateTemplate
        self.downloadGateway = downloadGateway
    }
    
    func formation(with indicators: [IndicatorsCounter],
                   template: TemplateReport,
                   userCompany: UserUtilitiesCompany,
                   completionHandler: @escaping (Result<SendReportModel, Error>) -> Void) {
        downloadTemoplateContent(indicators: indicators, with: template, userCompany: userCompany) { (result) in
            switch result {
            case let .success(context):
                let model = SendReportModel(type: template.type,
                                            sendTo: template.sendTo,
                                            content: context,
                                            indicators: indicators)
                completionHandler(.success(model))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
    
    private func downloadTemoplateContent(indicators: [IndicatorsCounter],
                                          with template: TemplateReport,
                                          userCompany: UserUtilitiesCompany,
                                          completionHandler: @escaping (_ result: Result<String, Error>) -> Void) {
        downloadGateway.download(parameter: template, progressHandler: { (progress) in
            
        }, complationHandler: { [weak self, indicators, userCompany] result in
            guard let `self` = self else { return }
            switch result {
            case let .success(content):
                print(content)
                self.createTemplate(indicators: indicators,
                                    templateContent: content,
                                    userCompany: userCompany,
                                    completionHandler: completionHandler)
            case let .failure(error):
                completionHandler(.failure(error))
            }
        })
    }
    
    private func createTemplate(indicators: [IndicatorsCounter],
                                templateContent: String,
                                userCompany: UserUtilitiesCompany,
                                completionHandler: @escaping (_ result: Result<String, Error>) -> Void) {
        generateTemplate.generate(with: indicators,
                                  by: userCompany,
                                  template: templateContent) { (result) in
            switch result {
            case let .success(content):
                completionHandler(.success(content))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
}
