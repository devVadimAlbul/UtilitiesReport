//
//  UserCompanyItemTableViewCell.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/12/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import UIKit



protocol UserCompanyItemViewCell: BasicVeiwCellProtocol {
    func displayEmblem(_ emlem: UIImage?)
    func displayName(_ name: String?)
    func displayAccountNumber(_  number: String)
    func displayIndicators(_ models: [LastInticatorModelView])
}

class UserCompanyItemTableViewCell: UITableViewCell, UserCompanyItemViewCell {

    // MARK: IBOutlet
    @IBOutlet weak var imgEmblem: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var stackViewIndicators: UIStackView!
    
    // MARK: life-cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: display methods
    func displayName(_ name: String?) {
        lblName.text = name
    }
    
    func displayAccountNumber(_ number: String) {
        lblAccountNumber.text = number
    }
    
    func displayEmblem(_ emlem: UIImage?) {
        imgEmblem.image = emlem?.withRenderingMode(.alwaysTemplate)
        imgEmblem.tintColor = .white
    }
    
    func displayIndicators(_ models: [LastInticatorModelView]) {
        stackViewIndicators.arrangedSubviews.forEach({$0.removeFromSuperview()})
        
        models.forEach { (model) in
            let view = LastIndicatorView()
            stackViewIndicators.addArrangedSubview(view)
            view.displayName(model.name)
            view.displayMonths(model.months)
            view.displayValue(model.value)
        }
        setNeedsDisplay()
    }
}
