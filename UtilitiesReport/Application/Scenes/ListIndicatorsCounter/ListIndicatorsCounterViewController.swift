import UIKit

protocol ListIndicatorsCounterView: AnyObject {
    func displayPageTitle(_ title: String)
    func displayError(_ message: String)
    func displayActionSheet(by model: AlertModelView)
    func displayImagePicker(sourceType: UIImagePickerController.SourceType)
    func reloadAllData()
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
    
    func displayActionSheet(by model: AlertModelView) {
        presentActionSheet(by: model)
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
        tableView.reloadData()
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
            
        }
    }
}