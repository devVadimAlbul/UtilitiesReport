//
//  TemplateParser.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/28/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import Stencil

protocol TemplateParser {
    func render(template: String, context: [String: Any],
                completionHandler: @escaping (Result<String>) -> Void)
}

class TemplateParserImpl: TemplateParser {
    
    private let environment: Environment
    
    init(environment: Environment = Environment()) {
        self.environment = environment
    }
    
    func render(template: String, context: [String: Any],
                completionHandler: @escaping (Result<String>) -> Void) {
        do {
            let rendered = try environment.renderTemplate(string: template, context: context)
            completionHandler(.success(rendered))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
