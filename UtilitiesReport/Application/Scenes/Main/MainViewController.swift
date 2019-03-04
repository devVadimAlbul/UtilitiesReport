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
        setupNavigationItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainPresenter?.loadContent()
    }
    
    // MARK: setup func
    func setupNavigationItems() {
        let addNavItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                         action: #selector(actionAddBarItem))
        navigationItem.setRightBarButton(addNavItem, animated: false)
    }
    
    private func setupTableViewParams() {
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 16, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        registerCells()
    }
    
    private func registerCells() {
        tableView.register(UserProfileTableViewCell.nib(),
                           forCellReuseIdentifier: UserProfileTableViewCell.identifier)
        tableView.register(EmptyListUserCompaniesTableViewCell.nib(),
                           forCellReuseIdentifier: EmptyListUserCompaniesTableViewCell.identifier)
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
    
    // MARK: config tableview cells
    fileprivate func getTableViewCell(type: TypeCellForMainView, at indexPath: IndexPath) -> UITableViewCell {
        switch type {
        case .userProfileCell:
            return tableView.dequeueReusableCell(withIdentifier: UserProfileTableViewCell.identifier,
                                                 for: indexPath)
        case .listUserCompaniesCell:
            return UITableViewCell()
        case .emptyListUserCompaniesCell:
            return tableView.dequeueReusableCell(
                withIdentifier: EmptyListUserCompaniesTableViewCell.identifier,
                for: indexPath)
        }
    }
    
    // MARK: Action
    @objc func actionAddBarItem(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
}

// MARK: - extension: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            mainPresenter?.router.pushToTextRecognizer(with: image, delegate: self)
        }
        picker.dismiss(animated: false, completion: nil)
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

extension MainViewController: TextRecognizerImageDelegate {
    
    func textRecognizerImage(_ viewRecognizer: TextRecognizerImageViewController, didRecognizedText text: String) {
        ProgressHUD.success(text, withDelay: 0.5)
        print(text)
    }
}
