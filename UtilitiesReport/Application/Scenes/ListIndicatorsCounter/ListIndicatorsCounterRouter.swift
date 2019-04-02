//
//  ListIndicatorsCounterRouter.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/14/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit.UIImage

protocol ListIndicatorsCounterRouter {
    func pushToTextRecognizer(with image: UIImage, delegate: TextRecognizerImageDelegate)
    func pushToFomIndicator(with indicator: IndicatorsCounter, to company: UserUtilitiesCompany)
    func presentActionSheet(by model: AlertModelView)
}

class ListIndicatorsCounterRouterImpl: ListIndicatorsCounterRouter {
    
    private weak var viewController: ListIndicatorsCounterViewController?
    
    init(viewController: ListIndicatorsCounterViewController) {
        self.viewController = viewController
    }
    
    func pushToTextRecognizer(with image: UIImage, delegate: TextRecognizerImageDelegate) {
        let viewController = TextRecognizerImageViewController()
        viewController.delegate = delegate
        viewController.configurator = TextRecognizerImageConfiguratorImpl(image: image)
        self.viewController?.navigationController?.pushViewController(viewController, animated: false)
    }
    
    func pushToFomIndicator(with indicator: IndicatorsCounter, to company: UserUtilitiesCompany) {
        let formVC = FormIndicatorCounterViewController()
        formVC.configurator = FormIndicatorCounterConfiguratorImpl(indicator: indicator,
                                                                   userUntilitesCompany: company)
        self.viewController?.navigationController?.pushViewController(formVC, animated: true)
    }
    
    func presentActionSheet(by model: AlertModelView) {
        viewController?.presentActionSheet(by: model)
    }
}
