//
//  TextDetectorViewController.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/23/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import UIKit

protocol TextRecognizerImageView: AnyObject {
    func displayPageTitle(_ title: String)
    func displayError(message: String)
    func displaySuccess(_ text: String)
    func displayRecognizeTextSuccess(_ text: String)
    func displayRecognizeTextWarring(_ message: String)
}

protocol TextRecognizerImageDelegate: AnyObject {
    func textRecognizerImage(_ viewRecognizer: TextRecognizerImageViewController,
                             didRecognizedText text: String)
}

class TextRecognizerImageViewController: BasicViewController, TextRecognizerImageView {
    
    // MARK: IBOutlet
    @IBOutlet weak var cropView: CropView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblRecord: UILabel!
    
    // MARK: property
    weak var delegate: TextRecognizerImageDelegate?
    var configurator: TextRecognizerImageConfigurator!
    private var timer: Timer?
    private var timeInterval: TimeInterval = 1
    private var saveBtn: UIBarButtonItem!
    var textRecPresenter: TextRecognizerImagePresenter? {
        return presenter as? TextRecognizerImagePresenter
    }
    var contentImage: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            scrollView.contentSize = newValue?.size ?? .zero
        }
    }
    var cropArea: CGRect {
        let scale = 1/scrollView.zoomScale
        let holeRect = cropView.calculateCropFrame()
        let imgX: CGFloat = (scrollView.contentOffset.x + holeRect.origin.x) * scale
        let imgY: CGFloat =  (scrollView.contentOffset.y + holeRect.origin.y) * scale
        let imgW = holeRect.width * scale
        let imgH = holeRect.height * scale
        print("cropArea x: \(imgX) y: \(imgY) w: \(imgW) h: \(imgH)")
        let cropRect = CGRect(x: imgX, y: imgY, width: imgW, height: imgH)
        return cropRect
    }
    
    // MARK: life-cycle
    override func viewDidLoad() {
        configurator?.configure(viewController: self)
        super.viewDidLoad()
        setupContentUI()
        setupToolBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    // MARK: setup UI
    fileprivate func setupContentUI() {
        scrollView.delegate = self
        lblRecord.text = nil
        lblState.text = nil
        let cropFrame = cropView.calculateCropFrame()
        let imageFrame = imageView.getImageFrame(in: self.scrollView.bounds)
        scrollView.contentInset = UIEdgeInsets(top: cropFrame.origin.y - imageFrame.origin.y,
                                               left: cropFrame.minX,
                                               bottom: imageFrame.maxY - cropFrame.maxY,
                                               right: imageFrame.maxX - cropFrame.maxX)
        updateZoomScaleForSize(contentImage?.size ?? .zero)
        scrollView.contentOffset = .zero
        startTimer()
    }
    
    fileprivate func setupToolBar() {
        saveBtn = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(actionSave))
        saveBtn.isEnabled = false
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [spacer, saveBtn]
    }
    
    fileprivate func updateZoomScaleForSize(_ size: CGSize) {
        let widthScale = scrollView.bounds.width / size.width
        let heightScale = scrollView.bounds.height / size.height
        let minScale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = minScale/1.5
        scrollView.maximumZoomScale = minScale * 4
        scrollView.setZoomScale(minScale, animated: false)
    }
    
    // MARK: timer action
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                     target: self,
                                     selector: #selector(actionRecognize),
                                     userInfo: nil,
                                     repeats: false)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: dispaly methods
    func displayPageTitle(_ title: String) {
        self.title = title
    }
    
    func displayError(message: String) {
        ProgressHUD.dismiss()
        showErrorAlert(message: message)
    }
    
    func displaySuccess(_ text: String) {
        ProgressHUD.success("Success Recognized!", withDelay: 0.3)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
            self.textRecPresenter?.router.backToMainPage()
            self.delegate?.textRecognizerImage(self, didRecognizedText: text)
        }
    }
    
    func displayRecognizeTextSuccess(_ text: String) {
        ProgressHUD.dismiss()
        saveBtn.isEnabled = true
        lblRecord.text = text
        lblState.text = "Success with recognized text!"
        lblState.textColor = #colorLiteral(red: 0.4313918948, green: 0.7170374393, blue: 0, alpha: 1)
    }
    
    func displayRecognizeTextWarring(_ message: String) {
        ProgressHUD.dismiss()
        saveBtn.isEnabled = false
        lblRecord.text = nil
        lblState.text = message
        lblState.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
    }
    
    // MARK: Action
    @objc func actionRecognize() {
        guard let cropImage = imageView.image?.croppedInRect(cropArea) else { return }
//        imageView.image = cropImage
        ProgressHUD.show(message: "Recognizing...")
        textRecPresenter?.textRecognize(image: cropImage)
    }
    
    @objc func actionSave(_ sender: UIBarButtonItem) {
        textRecPresenter?.saveRecognizedText()
    }
}

// MARK: - extension: UIScrollViewDelegate
extension TextRecognizerImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
         startTimer()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         startTimer()
    }
}
