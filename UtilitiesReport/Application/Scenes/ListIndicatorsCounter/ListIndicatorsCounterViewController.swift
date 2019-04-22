import UIKit

protocol ListIndicatorsCounterView: AnyObject {
    func displayPageTitle(_ title: String)
    func displayError(_ message: String)
    func displayMessage(_ message: String)
    func displayImagePicker(sourceType: UIImagePickerController.SourceType)
    func reloadAllData()
    func displayProgress()
    func removeCell(by indexPath: IndexPath)
}

class ListIndicatorsCounterViewController: BasicViewController, ListIndicatorsCounterView {
    
    // MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!
    var configurator: ListIndicatorsCounterConfigurator!
    
    // MARK: preoprties
    private var listPresenter: ListIndicatorsCounterPresenter? {
        return presenter as? ListIndicatorsCounterPresenter
    }

    // MARK: life-cycle
    override func viewDidLoad() {
        configurator?.configure(viewController: self)
        super.viewDidLoad()
        setupTableView()
        setupNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listPresenter?.updateContent()
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
    
    func displayMessage(_ message: String) {
        ProgressHUD.dismiss()
        let modelView = AlertModelView(title: message, message: nil, actions: [
                AlertActionModelView(title: "OK", action: nil)
            ])
        presentAlert(by: modelView)
    }
    
    func displayProgress() {
        ProgressHUD.show()
    }
    
    func displayImagePicker(sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = sourceType
            present(imagePicker, animated: true, completion: nil)
        } else {
            let name = sourceType == .camera ? "Camera" : "Photo library"
            showErrorAlert(message: URError.notAvailable(name).localizedDescription)
        }
    }
    
    func reloadAllData() {
        ProgressHUD.dismiss()
        tableView.reloadData()
    }
    
    func removeCell(by indexPath: IndexPath) {
        if tableView.numberOfSections > indexPath.section &&
            tableView.numberOfRows(inSection: indexPath.section) > indexPath.row {
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    // MARK: target action
    @objc func actionAddNavBar() {
        listPresenter?.actionAddNewIndicator()
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = listPresenter?.titleForHeader(in: section) else { return nil }
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        let label = UILabel()
        label.frame = CGRect.init(x: 10, y: 5, width: headerView.frame.width-20, height: headerView.frame.height-10)
        label.text = title
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = #colorLiteral(red: 0.1215686275, green: 0.1254901961, blue: 0.2549019608, alpha: 1)
        headerView.addSubview(label)
        return headerView
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return listPresenter?.canEditCell(at: indexPath) ?? false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            listPresenter?.actionDeleteIndicator(for: indexPath)
        }
    }
}

// MARK: - extension: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ListIndicatorsCounterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            listPresenter?.router.pushToTextRecognizer(with: image, delegate: self)
        }
        picker.dismiss(animated: false, completion: nil)
    }
}

// MARK: extension: TextRecognizerImageDelegate
extension ListIndicatorsCounterViewController: TextRecognizerImageDelegate {
    
    func textRecognizerImage(_ viewRecognizer: TextRecognizerImageViewController,
                             didRecognizedText text: String) {
        listPresenter?.actionSaveIndicator(value: text.onlyDigits())
    }
}

// MARK: extension: ItemIndicatorCounterCellDelegate
extension ListIndicatorsCounterViewController: ItemIndicatorCounterCellDelegate {
    
    func actionSend(view: ItemIndicatorCounterViewCell) {
        if let cell = view as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            ProgressHUD.show()
            listPresenter?.actionSendItem(at: indexPath)
        }
    }
}
