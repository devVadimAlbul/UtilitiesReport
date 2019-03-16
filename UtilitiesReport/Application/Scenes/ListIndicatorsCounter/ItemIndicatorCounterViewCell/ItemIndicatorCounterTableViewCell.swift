import UIKit


protocol ItemIndicatorCounterViewCell: BasicVeiwCellProtocol {
    func displayDateMonths(_ date: String)
    func displayCounter(_ name: String?)
    func displayValue(_ value: String)
    func displayState(_ state: String)
}

class ItemIndicatorCounterTableViewCell: UITableViewCell, ItemIndicatorCounterViewCell {

    // MARK: IBOutlet
    @IBOutlet weak var lblDateMonths: UILabel!
    @IBOutlet weak var lblCounterName: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblState: UILabel!
    
    // MARK: life-cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: display methods
    func displayDateMonths(_ date: String) {
        lblDateMonths.text = " \(date) "
    }
    
    func displayState(_ state: String) {
        lblState.text = state
    }
    
    func displayValue(_ value: String) {
        lblValue.text = value
    }
    
    func displayCounter(_ name: String?) {
        lblCounterName.text = name
        lblCounterName.isHidden = name == nil
    }

}
