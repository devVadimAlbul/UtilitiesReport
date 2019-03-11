//
//  InfoFromItemTableViewCell.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/10/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import UIKit

protocol InfoFromItemViewCell: BasicVeiwCellProtocol {
    var identifier: String? { get set }
    func displayTitle(_ text: String)
    func displayDetail(_ text: String)
}

class InfoFromItemTableViewCell: UITableViewCell, InfoFromItemViewCell {

    // MARK: life-cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: preoeprty
    var identifier: String?
    
    // MARK: display methods
    func displayTitle(_ text: String) {
        self.textLabel?.text = text
    }
    
    func displayDetail(_ text: String) {
        self.detailTextLabel?.text = text
    }
}
