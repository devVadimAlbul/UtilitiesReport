//
//  EmailSendReportService.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 4/20/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit.UIViewController
import MessageUI

protocol EmailSendReportService: SendReportServiceProtocol {
    
}

class EmailSendReportServiceImpl: NSObject, EmailSendReportService {
    
    private weak var viewController: UIViewController?
    private var completionCommand: CommandWith<Result<SendReportStatus>>?
    private var queue: DispatchQueue
    
    init(viewController: UIViewController, on queue: DispatchQueue = .main) {
        self.viewController = viewController
        self.queue = queue
        super.init()
    }
    
    func send(model: SendReportModel, completionHandler: @escaping (Result<SendReportStatus>) -> Void) {
        guard MFMailComposeViewController.canSendMail(),
            let viewController = self.viewController else {
            completionHandler(.failure(URError.reportNotSend))
            return
        }
        
        guard model.sendTo.isEmailValid else {
            completionHandler(.failure(URError.emailInvalid))
            return
        }
        
        completionCommand = CommandWith(action: completionHandler).dispatched(on: queue)
        let mailController = MFMailComposeViewController()
        mailController.mailComposeDelegate = self
        mailController.setMessageBody(model.content, isHTML: false)
        mailController.setToRecipients([model.sendTo])
        DispatchQueue.main.async {
            ProgressHUD.dismiss()
            viewController.present(mailController, animated: true, completion: nil)
        }
    }
}

extension EmailSendReportServiceImpl: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            if let error = error {
                self.completionCommand?.perform(with: .failure(error))
            } else {
                switch result {
                case .sent:
                    self.completionCommand?.perform(with: .success(.sent))
                case .cancelled, .saved:
                    self.completionCommand?.perform(with: .success(.cancelled))
                case .failed:
                    self.completionCommand?.perform(with: .failure(URError.reportNotSend))
                }
            }
            self.completionCommand = nil
        }
    }
}
