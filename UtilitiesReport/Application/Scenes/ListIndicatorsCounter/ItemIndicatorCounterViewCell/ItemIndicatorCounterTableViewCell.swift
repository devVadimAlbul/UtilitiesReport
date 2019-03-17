import UIKit

protocol ItemIndicatorCounterCellDelegate: AnyObject {
    func actionSend(view: ItemIndicatorCounterViewCell)
}

protocol ItemIndicatorCounterViewCell: BasicVeiwCellProtocol {
    var delegate: ItemIndicatorCounterCellDelegate? { get set }
    func displayDateMonths(_ date: String)
    func displayCounter(_ name: String?)
    func displayValue(_ value: String)
    func displayState(_ state: String, color: UIColor)
    func displayButtonSend(title: String, isHidden: Bool)
}

class ItemIndicatorCounterTableViewCell: UITableViewCell, ItemIndicatorCounterViewCell {

    // MARK: IBOutlet
    @IBOutlet weak var lblDateMonths: UILabel!
    @IBOutlet weak var lblCounterName: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var btnSend: UIButton!
    
    // MARK: property
    weak var delegate: ItemIndicatorCounterCellDelegate?
    
    // MARK: life-cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: display methods
    func displayDateMonths(_ date: String) {
        lblDateMonths.text = " \(date) "
    }
    
    func displayState(_ state: String, color: UIColor) {
        lblState.text = state
        lblState.textColor = color
    }
    
    func displayValue(_ value: String) {
        lblValue.text = value
    }
    
    func displayCounter(_ name: String?) {
        lblCounterName.text = name
        lblCounterName.isHidden = name == nil
    }
    
    func displayButtonSend(title: String, isHidden: Bool) {
        btnSend.setTitle(title, for: .normal)
        btnSend.isHidden = isHidden
    }

    // MARK: IBAction
    @IBAction func clickedSend(_ sender: Any) {
        delegate?.actionSend(view: self)
    }
}
