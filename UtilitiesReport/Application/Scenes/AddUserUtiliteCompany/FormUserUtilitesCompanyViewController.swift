//
//  AddUserUtilitesCompanyViewController.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/3/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import UIKit

protocol FormUserUtilitesCompanyView: AnyObject {
    
}

class FormUserUtilitesCompanyViewController: BasicViewController, FormUserUtilitesCompanyView, UIScrollViewDelegate {
    
    // MARK: IBOutlet
    @IBOutlet weak var btnSave: ButtonRound!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var heightTableViewConstraint: NSLayoutConstraint!
    
    // MARK: property
    var configurator: FormUserUtilitesCompanyConfigurator!
    fileprivate var formPresenter: FormUserUtilitesCompanyPresenter? {
        return presneter as? FormUserUtilitesCompanyPresenter
    }
    private var observers = [NSKeyValueObservation]()
    

    // MARK: life-cycle
    override func viewDidLoad() {
        configurator?.configure(viewController: self)
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserver()
        observers.removeAll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    fileprivate func addObserver() {
        let handlerChangeContentSize = {
            [weak self] (tableView: UITableView, change: NSKeyValueObservedChange<CGSize>) in
            guard let `self` = self else { return }
            if let contentSize = change.newValue {
                print("contentSize:", contentSize)
                self.heightTableViewConstraint?.constant = contentSize.height
                self.updateConstraints(animated: true)
            }
        }
        
        let observe = tableView.observe(\.contentSize, options: [.new],
                          changeHandler: handlerChangeContentSize)
        observers.append(observe)
    }
    
    // MARK: IBAction
    @IBAction func clickedBtnSave(_ sender: UIButton) {
        
    }
    
}

// MARK: - extension: UITableViewDelegate, UITableViewDataSource
extension FormUserUtilitesCompanyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
