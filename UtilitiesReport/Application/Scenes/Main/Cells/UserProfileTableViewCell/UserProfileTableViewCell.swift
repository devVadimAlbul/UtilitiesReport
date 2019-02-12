//
//  UserProfileTableViewCell.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/12/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import UIKit

protocol UserProfileViewCell: BasicVeiwCellProtocol {
    func display(name: String)
    func display(phoneNumber: String)
    func display(address: String)
}

class UserProfileTableViewCell: UITableViewCell, UserProfileViewCell {
    
    // MARK: IBOutlet
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhoneTitle: UILabel!
    @IBOutlet weak var lblPhoneValue: UILabel!
    @IBOutlet weak var lblAddressTitle: UILabel!
    @IBOutlet weak var lblAddressValue: UILabel!
    
    // MARK: life-cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: UserProfileViewCell protocols methods
    func display(name: String) {
        self.lblName.text = name
    }
    
    func display(address: String) {
        self.lblAddressValue.text = address
    }
    
    func display(phoneNumber: String) {
        self.lblPhoneValue.text = phoneNumber
    }
    
}
