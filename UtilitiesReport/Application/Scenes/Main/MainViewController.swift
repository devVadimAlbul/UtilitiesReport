//
//  MainViewController.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/9/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import UIKit

protocol MainView: AnyObject {
    func displayError(message: String)
    func updateUIContent()
    func displayPageTitle(_ title: String)
}

class MainViewController: BasicViewController, MainView {
    
    // MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: property
    var configurator: MainConfigurator!
    var mainPresenter: MainPresenter? {
        return presneter as? MainPresenter
    }

    // MARK: life-cycle
    override func viewDidLoad() {
        configurator.configure(viewController: self)
        super.viewDidLoad()
        setupTableViewParams()
        setupNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainPresenter?.loadContent()
    }
    
    // MARK: setup func
    private func setupTableViewParams() {
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 16, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        registerCells()
    }
    
    private func registerCells() {
        tableView.register(UserProfileTableViewCell.nib(),
                           forCellReuseIdentifier: UserProfileTableViewCell.identifier)
        tableView.register(EmptyListTableViewCell.nib(),
                           forCellReuseIdentifier: EmptyListTableViewCell.identifier)
        tableView.register(UserCompanyItemTableViewCell.nib(),
                           forCellReuseIdentifier: UserCompanyItemTableViewCell.identifier)
    }
    
    private func setupNavigationItem() {
        let addBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "add"), style: .done,
                                           target: self, action: #selector(actionAddNavBar))
        self.navigationItem.setRightBarButton(addBarButton, animated: true)
    }
    
    // MARK: dispaly methods
    func displayPageTitle(_ title: String) {
        self.title = title
    }
    
    func displayError(message: String) {
        showErrorAlert(message: message)
    }
    
    func updateUIContent() {
        tableView.reloadData()
    }
    
    // MARK: targat action
    @objc func actionAddNavBar() {
        mainPresenter?.actionAddNew()
    }
    
    // swiftlint:disable force_cast
    // MARK: config tableview cells
    fileprivate func getTableViewCell(type: TypeCellForMainView, at indexPath: IndexPath) -> UITableViewCell {
        switch type {
        case .userProfileCell:
            return tableView.dequeueReusableCell(withIdentifier: UserProfileTableViewCell.identifier,
                                                 for: indexPath)
        case .listUserCompaniesCell:
            return tableView.dequeueReusableCell(withIdentifier: UserCompanyItemTableViewCell.identifier,
                                                 for: indexPath)
        case .emptyListUserCompaniesCell:
            return tableView.dequeueReusableCell(withIdentifier: EmptyListTableViewCell.identifier,
                                                 for: indexPath) as! EmptyListTableViewCell
        }
    }
    
}

// MARK: - extension: UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return mainPresenter?.numberOfSections ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainPresenter?.numberOfRows(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let mainPresenter = mainPresenter,
            let type = mainPresenter.cellType(at: indexPath) else {
                return UITableViewCell()
        }
      
        let cell = getTableViewCell(type: type, at: indexPath)
        mainPresenter.configure(cellView: cell, for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainPresenter?.didSelectCell(at: indexPath)
    }
}

// MARK: - extension: AddUserCompanyDelegate
extension MainViewController: AddUserCompanyDelegate {
    
    func actionAddUserCompany() {
        mainPresenter?.actionAddNew()
    }
}
