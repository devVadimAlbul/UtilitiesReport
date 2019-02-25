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
    func addRectangleView(_ identifier: String, in frame: CGRect, color: UIColor)
}

class TextRecognizerImageViewController: BasicViewController, TextRecognizerImageView {
    
    // MARK: IBOutlet
    @IBOutlet weak var cropView: CropView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: property
    var configurator: TextRecognizerImageConfigurator!
    var textRecPresenter: TextRecognizerImagePresenter? {
        return presneter as? TextRecognizerImagePresenter
    }
    var contentImage: UIImage! {
        didSet {
            imageView.image = contentImage
            scrollView.contentSize = contentImage.size
        }
    }
    var cropArea: CGRect {
        guard let size = imageView.image?.size else {
            return imageView.bounds
        }
        let factor = size.width/view.frame.width
        let scale = 1/scrollView.zoomScale
        let cropFrame = cropView.areaCropFrame
        let imageFrame = imageView.imageFrame()
        let xPos = (scrollView.contentOffset.x + cropFrame.origin.x - imageFrame.origin.x) * scale * factor
        let yPos = (scrollView.contentOffset.y + cropFrame.origin.y - imageFrame.origin.y) * scale * factor
        let width = cropView.frame.size.width * scale * factor
        let height = cropView.frame.size.height * scale * factor
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
        updateMinZoomScaleForSize(contentImage.size)
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
        showErrorAlert(message: message)
    }
    
    func addRectangleView(_ identifier: String, in frame: CGRect, color: UIColor) {
        //        let transformedRect = frame.applying(transformMatrix)
        //        let rect = imageView.convert(imageView.frame, to: view)
        //        print("addRectangleView[\(identifier)], rect: ", frame, transformedRect, rect)
        //        let rectangleView = UIView(frame: transformedRect)
        //        rectangleView.viewIdentifier = identifier
        //        rectangleView.layer.cornerRadius = configurator.rectangleViewCornerRadius
        //        rectangleView.alpha = configurator.rectangleViewAlpha
        //        rectangleView.backgroundColor = color
        //        imageView.addSubview(rectangleView)
    }
    
    //    private func calculateTransformMatrix() -> CGAffineTransform {
    //        guard let image = imageView.image else { return CGAffineTransform() }
    //        let imageViewWidth = imageView.frame.size.width
    //        let imageViewHeight = imageView.frame.size.height
    //        let imageWidth = image.size.width
    //        let imageHeight = image.size.height
    //
    //        let imageViewAspectRatio = imageViewWidth / imageViewHeight
    //        let imageAspectRatio = imageWidth / imageHeight
    //        let scale = (imageViewAspectRatio > imageAspectRatio) ?
    //            imageViewHeight / imageHeight :
    //            imageViewWidth / imageWidth
    //
    //        let scaledImageWidth = imageWidth * scale
    //        let scaledImageHeight = imageHeight * scale
    //        let xValue = (imageViewWidth - scaledImageWidth) / CGFloat(2.0)
    //        let yValue = (imageViewHeight - scaledImageHeight) / CGFloat(2.0)
    //
    //        var transform = CGAffineTransform.identity.translatedBy(x: xValue, y: yValue)
    //        transform = transform.scaledBy(x: scale, y: scale)
    //        return transform
    //    }
    
    // MARK: Action
    @objc func actionRecognize(_ sender: UIBarButtonItem) {
        guard let cropImage = imageView.image?.cropped(boundingBox: cropArea) else { return }
        textRecPresenter?.textRecognize(image: cropImage)
    }
}

// MARK: - extension: UIScrollViewDelegate
extension TextRecognizerImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
