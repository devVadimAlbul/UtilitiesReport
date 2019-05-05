//
//  SmsSendReportService.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 4/20/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit.UIViewController
import MessageUI

protocol SmsSendReportService: SendReportServiceProtocol {
    
}

class SmsSendReportServiceImpl: NSObject, SmsSendReportService {
    
    private weak var viewController: UIViewController?
    private var completionCommand: CommandWith<Result<SendReportStatus>>?
    private var queue: DispatchQueue
    
    init(viewController: UIViewController, on queue: DispatchQueue = .main) {
        self.viewController = viewController
        self.queue = queue
        super.init()
    }
    
    
    func send(model: SendReportModel,
              completionHandler: @escaping (Result<SendReportStatus>) -> Void) {
        guard MFMessageComposeViewController.canSendText(),
            let viewController = self.viewController else {
            completionHandler(.failure(URError.reportNotSend))
            return
        }
        guard model.sendTo.isPhoneNumberValid else {
            completionHandler(.failure(URError.phoneNumberInvalid))
            return
        }
        
        completionCommand = CommandWith(action: completionHandler).dispatched(on: queue)
        let smsController = MFMessageComposeViewController()
        smsController.body = model.content
        smsController.recipients = [model.sendTo]
        smsController.messageComposeDelegate = self
        ProgressHUD.dismiss()
        viewController.present(smsController, animated: true, completion: nil)
    }
}

extension SmsSendReportServiceImpl: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true) {
            switch result {
            case .sent:
                self.completionCommand?.perform(with: .success(.sent))
            case .cancelled:
                self.completionCommand?.perform(with: .success(.cancelled))
            case .failed:
                self.completionCommand?.perform(with: .failure(URError.reportNotSend))
            @unknown default:
                break
            }
            self.completionCommand = nil
        }
    }
}
