import Foundation
import UIKit

protocol ViewFromXibProtocol {
    
}

extension ViewFromXibProtocol where Self: UIView {
    
    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.theClassName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view
    }
}
