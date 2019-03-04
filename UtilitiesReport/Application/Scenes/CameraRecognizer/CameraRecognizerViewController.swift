//
//  CameraRecognizerViewController.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/26/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import UIKit
import AVFoundation

protocol CameraRecognizerView: AnyObject {
    var configurator: CameraRecognizerConfigurator! { get set }
}

class CameraRecognizerViewController: BasicViewController, CameraRecognizerView {
    
    // MARK: property
    var configurator: CameraRecognizerConfigurator!
    fileprivate var cameraPresenter: CameraRecognizerPresenter? {
        return presneter as? CameraRecognizerPresenter
    }
    private(set) lazy var cameraLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
    
    private lazy var captureSession: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSession.Preset.photo
        
        guard
            let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
            let input = try? AVCaptureDeviceInput(device: backCamera)
            else {
                return session
        }
        
        session.addInput(input)
        return session
    }()

    // MARK: life-cycle
    override func viewDidLoad() {
        configurator.configure(viewController: self)
        super.viewDidLoad()
        setupCameraLayer()
    }
    
    func setupCameraLayer() {
        let output = AVCaptureVideoDataOutput()
        guard captureSession.canAddOutput(output) else { return }
        captureSession.addOutput(output)
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "MyQueue"))
        output.alwaysDiscardsLateVideoFrames = true
        
        let connection = output.connection(with: .video)
        connection?.videoOrientation = .portrait
        
        cameraLayer.videoGravity = .resizeAspectFill
        cameraLayer.frame = view.bounds
        view.layer.addSublayer(cameraLayer)
    }
}


extension CameraRecognizerViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
}
