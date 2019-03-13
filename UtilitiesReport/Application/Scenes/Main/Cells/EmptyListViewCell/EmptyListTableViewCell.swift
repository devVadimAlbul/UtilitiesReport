//
//  EmptyListUserCompaniesTableViewCell.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/2/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import UIKit

protocol AddUserCompanyDelegate: AnyObject {
    func actionAddUserCompany()
}

protocol EmptyListViewCell: BasicVeiwCellProtocol {
    var delegate: AddUserCompanyDelegate? { get set }
    func displayNameAddButton(_ name: String)
    func displayMessage(_ message: String?)
}

class EmptyListTableViewCell: UITableViewCell, EmptyListViewCell {

    // MARK: IBOutlet
    @IBOutlet weak var btnAddNewCompany: ButtonRound!
    @IBOutlet weak var lblTitle: UILabel!
    
    // MARK: property
    weak var delegate: AddUserCompanyDelegate?
    
    // MARK: life-cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: display methods
    func displayNameAddButton(_ name: String) {
        btnAddNewCompany.setTitle(name, for: .normal)
    }
    
    func displayMessage(_ message: String?) {
        lblTitle.text = message
    }
    
    // MARK: IBAction
    @IBAction func clickedBtnAddNewCompany(_ sender: UIButton) {
        delegate?.actionAddUserCompany()
    }
}
