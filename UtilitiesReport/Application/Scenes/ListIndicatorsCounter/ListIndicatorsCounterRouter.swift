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
    func pushToFormIndicator(with indicator: IndicatorsCounter, to company: UserUtilitiesCompany)
    func presentActionSheet(by model: AlertModelView)
    func sendReport(model: SendReportModel, completionHandler: @escaping (Result<SendReportStatus>) -> Void)
}

class ListIndicatorsCounterRouterImpl: ListIndicatorsCounterRouter {
    
    private weak var viewController: ListIndicatorsCounterViewController?
    private var reportHelper: SendReportHelper
    
    init(viewController: ListIndicatorsCounterViewController, reportHelper: SendReportHelper) {
        self.viewController = viewController
        self.reportHelper = reportHelper
    }
    
    func pushToTextRecognizer(with image: UIImage, delegate: TextRecognizerImageDelegate) {
        let viewController = TextRecognizerImageViewController()
        viewController.delegate = delegate
        viewController.configurator = TextRecognizerImageConfiguratorImpl(image: image)
        self.viewController?.navigationController?.pushViewController(viewController, animated: false)
    }
    
    func pushToFormIndicator(with indicator: IndicatorsCounter, to company: UserUtilitiesCompany) {
        let formVC = FormIndicatorCounterViewController()
        formVC.configurator = FormIndicatorCounterConfiguratorImpl(indicator: indicator,
                                                                   userUntilitesCompany: company)
        self.viewController?.navigationController?.pushViewController(formVC, animated: true)
    }
    
    func presentActionSheet(by model: AlertModelView) {
        viewController?.presentActionSheet(by: model)
    }
    
    func sendReport(model: SendReportModel, completionHandler: @escaping (Result<SendReportStatus>) -> Void) {
        guard let viewController = self.viewController else { return }
        reportHelper.send(model: model, in: viewController, completionHandler: completionHandler)
    }
}
