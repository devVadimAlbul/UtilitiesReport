//
//  SectionViewHeaderAdd.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/9/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import UIKit

protocol SectionViewHeaderAddDelegate: AnyObject {
    func actionAddView(in view: SectionViewHeaderAddPtolocol)
}

protocol SectionViewHeaderAddPtolocol: BasicSectionHeaderVeiwProtocol {
    func displayTitle(_ title: String)
    var identifier: String? { get set }
    var delegate: SectionViewHeaderAddDelegate? { get set }
}

class SectionViewHeaderAdd: UITableViewHeaderFooterView, SectionViewHeaderAddPtolocol {

    // MARK: IBOutlet
    @IBOutlet weak var btnAdd: ButtonCircle!
    @IBOutlet weak var lblTitle: UILabel!
    
    // MARK: proeprty
    weak var delegate: SectionViewHeaderAddDelegate?
    var identifier: String?
    
    // MARK: display methods
    func displayTitle(_ title: String) {
        lblTitle?.text = title
    }
    
    // MARK: - IBAction
    @IBAction func clickedBtnAdd(_ sender: UIButton) {
        delegate?.actionAddView(in: self)
    }
}
