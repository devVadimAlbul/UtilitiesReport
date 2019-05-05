//
//  SelectIndicatorsCountersViewController.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 4/27/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import UIKit

protocol SelectIndicatorsCountersDelegate: AnyObject {
    func didSelectIndicators(_ indicators: [IndicatorsCounter])
    func didSelectNewIndicator(for counter: Counter)
}

protocol SelectIndicatorsCountersView: AnyObject {
    var delegate: SelectIndicatorsCountersDelegate? { get set }
    func displayPageTitle(_ title: String)
    func displayButtonTitle(_ title: String)
    func updateAllData()
    func displaySelected(indicators: [IndicatorsCounter])
    func displayNewItem(for counter: Counter)
    func displayError(message: String)
}

class SelectIndicatorsCountersViewController: BasicViewController, SelectIndicatorsCountersView {
    
    // MARK: IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSend: ButtonRound!
    @IBOutlet weak var heightTableConstraint: NSLayoutConstraint!
    
    // MARK: property
    weak var delegate: SelectIndicatorsCountersDelegate?
    var configurator: SelectIndicatorsCountersConfigurator!
    private var indicatorsPresenter: SelectIndicatorsCountersPresenter? {
        return presenter as? SelectIndicatorsCountersPresenter
    }
    private var observers = [NSKeyValueObservation]()
    
    // MARK: life-cycle
    override func viewDidLoad() {
        configurator?.configure(viewController: self)
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        observers.removeAll()
    }
    
    // MARK: setup UI
    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        registerNibs()
    }
    
    private func registerNibs() {
        tableView.register(SelectItemCounterTableViewCell.nib(),
                           forCellReuseIdentifier: SelectItemCounterTableViewCell.identifier)
    }
    
    // MARK: display methods
    func displayPageTitle(_ title: String) {
        self.lblTitle.text = title
    }
    
    func displayButtonTitle(_ title: String) {
        self.btnSend.setTitle(title, for: .normal)
    }
    
    func displaySelected(indicators: [IndicatorsCounter]) {
        self.dismiss(animated: true, completion: {
            self.delegate?.didSelectIndicators(indicators)
        })
    }
    
    func displayNewItem(for counter: Counter) {
        self.dismiss(animated: true) {
            self.delegate?.didSelectNewIndicator(for: counter)
        }
    }
    
    func displayError(message: String) {
        self.showErrorAlert(message: message)
    }
    
    // MARK: update UI
    func updateAllData() {
        tableView.reloadData()
    }
    
    // MARK: observer
    fileprivate func addObserver() {
        let handlerChangeContentSize = {
            [weak self] (tableView: UITableView, change: NSKeyValueObservedChange<CGSize>) in
            guard let `self` = self else { return }
            if let contentSize = change.newValue {
                let minHeight = self.view.bounds.height * 0.55
                self.heightTableConstraint?.constant = min(minHeight, contentSize.height)
                self.updateConstraints(animated: true)
            }
        }
        
        let observe = tableView.observe(\.contentSize, options: [.new],
                                        changeHandler: handlerChangeContentSize)
        observers.append(observe)
    }
    
    // MARK: IBAction
    @IBAction func clickedSend(_ sender: Any) {
        indicatorsPresenter?.actionSend()
    }
    
    @IBAction func clickedClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: extension: UITableViewDelegate, UITableViewDataSource
extension SelectIndicatorsCountersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return indicatorsPresenter?.numberOfSections ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return indicatorsPresenter?.numberOfRows(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SelectItemCounterTableViewCell.identifier,
            for: indexPath) as? SelectItemCounterTableViewCell else {
            return UITableViewCell()
        }
        indicatorsPresenter?.configure(cell: cell, for: indexPath)
        return cell
    }
}

// MARK: extension: SelectItemCounterDelegate
extension SelectIndicatorsCountersViewController: SelectItemCounterDelegate {
    
    func selectItemCounter(_ view: SelectItemCounterViewCell,
                           didSelectIndex index: Int, in list: [String]) {
        indicatorsPresenter?.selectItem(cell: view, at: index)
    }
    
    func actionAddNewItem(with view: SelectItemCounterViewCell) {
        indicatorsPresenter?.actionAddNewItem(with: view)
    }
}
