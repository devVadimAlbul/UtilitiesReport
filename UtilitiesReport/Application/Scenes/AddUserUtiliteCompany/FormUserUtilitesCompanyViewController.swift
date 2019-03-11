//
//  AddUserUtilitesCompanyViewController.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/3/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import UIKit

protocol FormUserUtilitesCompanyView: AnyObject {
    func displayPageTitle(_ title: String)
    func displayError(_ message: String)
    func reloadSection(_ index: Int)
    func insertSection(_ index: Int)
    func removeSection(_ index: Int)
    func insertCell(by indexPath: IndexPath)
    func reloadAllData()
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
        setupTableViewParams()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        observers.removeAll()
    }
    
    // MARK: setup func
    private func setupTableViewParams() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        registerCells()
    }
    
    private func registerCells() {
        tableView.register(SelectorFormItemTableViewCell.nib(),
                           forCellReuseIdentifier: SelectorFormItemTableViewCell.identifier)
        tableView.register(InputFormItemTableViewCell.nib(),
                           forCellReuseIdentifier: InputFormItemTableViewCell.identifier)
        tableView.register(InfoFromItemTableViewCell.nib(),
                           forCellReuseIdentifier: InfoFromItemTableViewCell.identifier)
        tableView.register(SectionViewHeaderAdd.nib(),
                           forHeaderFooterViewReuseIdentifier: SectionViewHeaderAdd.identifier)
    }
    
    
    // MARK: display methods
    func displayPageTitle(_ title: String) {
        self.title = title
    }
    
    func displayError(_ message: String) {
        showErrorAlert(message: message)
    }
    
    func reloadSection(_ index: Int) {
        if tableView.numberOfSections > index {
            let indexSet = IndexSet(arrayLiteral: index)
            tableView.reloadSections(indexSet, with: .none)
        }
    }
    
    func reloadAllData() {
        tableView.reloadData()
    }
    
    func insertSection(_ index: Int) {
        let indexSet = IndexSet(arrayLiteral: index)
        tableView.beginUpdates()
        tableView.insertSections(indexSet, with: .none)
        tableView.endUpdates()
        tableView.reloadSections(indexSet, with: .none)
//        tableView.reloadData()
    }
    
    func insertCell(by indexPath: IndexPath) {
        if tableView.numberOfSections > indexPath.section {
            tableView.insertRows(at: [indexPath], with: .bottom)
        }
    }
    
    func removeSection(_ index: Int) {
        if tableView.numberOfSections > index {
            let countRows = tableView.numberOfRows(inSection: index)
            let indexSet = IndexSet(arrayLiteral: index)
            tableView.beginUpdates()
            let indexPathes = (0..<countRows).map({IndexPath(row: $0, section: index)})
            tableView.deleteRows(at: indexPathes, with: .fade)
            tableView.deleteSections(indexSet, with: .fade)
            tableView.endUpdates()
        }
    }
    
    // MARK: observer
    fileprivate func addObserver() {
        let handlerChangeContentSize = {
            [weak self] (tableView: UITableView, change: NSKeyValueObservedChange<CGSize>) in
            guard let `self` = self else { return }
            if let contentSize = change.newValue {
                let minHeight = self.view.bounds.height * 0.55
                self.heightTableViewConstraint?.constant = min(minHeight, contentSize.height)
                self.updateConstraints(animated: true)
            }
        }
        
        let observe = tableView.observe(\.contentSize, options: [.new],
                          changeHandler: handlerChangeContentSize)
        observers.append(observe)
    }
    
    // MARK: IBAction
    @IBAction func clickedBtnSave(_ sender: UIButton) {
        formPresenter?.saveUserComapany()
    }
    
    fileprivate func getTableViewCell(_ tableView: UITableView,
                                      type: FormUserUtilitesCompanyItemType,
                                      at indexPath: IndexPath) -> UITableViewCell {
        switch type {
        case .accountNumber:
            return tableView.dequeueReusableCell(withIdentifier: InputFormItemTableViewCell.identifier,
                                                 for: indexPath)
        case .company:
            return tableView.dequeueReusableCell(withIdentifier: SelectorFormItemTableViewCell.identifier,
                                                 for: indexPath)
        case .counter:
            return tableView.dequeueReusableCell(withIdentifier: InfoFromItemTableViewCell.identifier,
                                                 for: indexPath)
        }
    }
}

// MARK: - extension: UITableViewDelegate, UITableViewDataSource
extension FormUserUtilitesCompanyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return formPresenter?.numberOfSections ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formPresenter?.numberOfRows(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let formPresenter = self.formPresenter,
            let type = formPresenter.cellType(at: indexPath) else {
                return UITableViewCell()
        }
        let cell = getTableViewCell(tableView, type: type, at: indexPath)
        formPresenter.configure(cellView: cell, for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let type = formPresenter?.getTypeHeaderView(by: section) else { return nil }
        switch type {
        case .addViewCounter:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionViewHeaderAdd.identifier)!
            formPresenter?.configure(view: header, for: section)
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let type = formPresenter?.getTypeHeaderView(by: section) else { return 0 }
        switch type {
        case .addViewCounter: return 60
        }
    }
}

// MARK: - extension: SelectorFormItemDelegate
extension FormUserUtilitesCompanyViewController: SelectorFormItemDelegate {
    
    func selectorFormItem(_ view: SelectorFormItemViewCell, didSelectIndex index: Int, in list: [String]) {
        formPresenter?.changedSelectItem(identifier: view.identifier, by: index)
    }
}

// MARK: - extension: InputFormItemDelegate
extension FormUserUtilitesCompanyViewController: InputFormItemDelegate {
    
    func inputFormItem(_ view: InputFormItemViewCell, didChangeVlaue value: String?) {
        formPresenter?.changedInputItem(identifier: view.identifier, value: value)
    }
}

// MARK: - extension: SectionViewHeaderAddDelegate
extension FormUserUtilitesCompanyViewController: SectionViewHeaderAddDelegate {
    
    func actionAddView(in view: SectionViewHeaderAddPtolocol) {
        guard let identifier = view.identifier else { return }
        formPresenter?.actionSectionAddView(by: identifier)
    }
}
