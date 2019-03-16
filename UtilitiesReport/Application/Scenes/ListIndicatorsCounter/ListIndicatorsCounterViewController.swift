import UIKit

protocol ListIndicatorsCounterView: AnyObject {
    func displayPageTitle(_ title: String)
    func displayError(_ message: String)
    func reloadAllData()
}

class ListIndicatorsCounterViewController: BasicViewController, ListIndicatorsCounterView {
    
    // MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!
    var configurator: ListIndicatorsCounterConfigurator!
    
    // MARK: preoprties
    private var listPresenter: ListIndicatorsCounterPresenter? {
        return presneter as? ListIndicatorsCounterPresenter
    }

    // MARK: life-cycle
    override func viewDidLoad() {
        configurator?.configure(viewController: self)
        super.viewDidLoad()
        setupTableView()
        setupNavigationItem()
    }
    
    
    // MARK: setup func
    private func setupTableView() {
        registerNibs()
    }
    
    private func registerNibs() {
        tableView.register(ItemIndicatorCounterTableViewCell.nib(),
                           forCellReuseIdentifier: ItemIndicatorCounterTableViewCell.identifier)
    }
    
    private func setupNavigationItem() {
        let addBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "add"), style: .done,
                                           target: self, action: #selector(actionAddNavBar))
        self.navigationItem.setRightBarButton(addBarButton, animated: true)
    }
    
    // MARK: display methods
    func displayPageTitle(_ title: String) {
        self.title = title
    }
    
    func displayError(_ message: String) {
        ProgressHUD.dismiss()
        showErrorAlert(message: message)
    }
    
    func reloadAllData() {
        tableView.reloadData()
    }
    
    // MARK: target action
    @objc func actionAddNavBar() {
        
    }
}

// MARK: - extension: UITableViewDelegate, UITableViewDataSource
extension ListIndicatorsCounterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listPresenter?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPresenter?.numberOfRows(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemIndicatorCounterTableViewCell.identifier,
                                                 for: indexPath)
        listPresenter?.configure(cell: cell, at: indexPath)
        
        return cell
    }
}
