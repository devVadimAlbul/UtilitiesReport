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
    
    // MARK: property
    weak var delegate: TextRecognizerImageDelegate?
    var configurator: TextRecognizerImageConfigurator!
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
        guard let size = contentImage?.size else {
            return imageView.bounds
        }
        let factor = size.width/view.frame.width
        let scale = 1/scrollView.zoomScale
        let cropFrame = cropView.areaCropFrame
        let imageFrame = imageView.imageFrame()
        let xPos = (scrollView.contentOffset.x + cropFrame.origin.x - imageFrame.origin.x) * scale * factor
        let yPos = (scrollView.contentOffset.y + cropFrame.origin.y - imageFrame.origin.y) * scale * factor
        let width = cropFrame.width * scale * factor
        let height = cropFrame.height * scale * factor
        return CGRect(x: xPos, y: yPos, width: width, height: height)
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
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    // MARK: setup UI
    fileprivate func setupContentUI() {
        scrollView.delegate = self
        scrollView.maximumZoomScale = 10.0
        let cropFrame = cropView.calculateCropFrame()
        let imageFrame = imageView.imageFrame()
        scrollView.contentInset = UIEdgeInsets(top: cropFrame.origin.y - imageFrame.origin.y,
                                               left: cropFrame.minX,
                                               bottom: imageFrame.maxY - cropFrame.maxY,
                                               right: imageFrame.maxX - cropFrame.maxX)
        updateMinZoomScaleForSize(contentImage?.size ?? .zero)
    }
    
    fileprivate func setupToolBar() {
        let crop = UIBarButtonItem(title: "Recognize", style: .done, target: self,
                                   action: #selector(actionRecognize))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [spacer, crop]
    }
    
    fileprivate func updateMinZoomScaleForSize(_ size: CGSize) {
        let widthScale = scrollView.bounds.width / size.width
        let heightScale = scrollView.bounds.height / size.height
        let minScale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = minScale
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
    
    // MARK: Action
    @objc func actionRecognize(_ sender: UIBarButtonItem) {
        guard let cropImage = imageView.image?.cropped(boundingBox: cropArea) else { return }
        ProgressHUD.show(message: "Recognizing...")
        textRecPresenter?.textRecognize(image: cropImage)
    }
}

// MARK: - extension: UIScrollViewDelegate
extension TextRecognizerImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
