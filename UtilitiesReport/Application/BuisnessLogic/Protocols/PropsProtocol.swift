import UIKit

protocol PropsProtocol {
  associatedtype Props
  
  var props: Props { get set }
  func render(props: Props)
}

enum PropsItemState {
  case valid
  case invalid(message: String)
}

enum PropsState {
  case edit
  case loading
  case falied(error: String)
  case success
}

extension PropsProtocol where Self: BasicViewController {
  
  func updateTextIfNeeded<T>(in textView: FormTextItemView,
                             with source: T,
                             using keyPath: KeyPath<T, String?>) {
    guard !textView.tfItem.isFirstResponder else { return }
    textView.value = source[keyPath: keyPath]
  }
 
  func updateItemState(_ state: PropsItemState, in textView: FormTextItemView) {
    switch state {
    case .valid:
      textView.isValid = true
    case .invalid(message: let message):
      textView.warningMessage = message
      textView.isValid = false
    }
  }
  
  func updatePageState(_ state: PropsState) {
    switch state {
    case .edit: ProgressHUD.dismiss()
    case .falied(error: let error):
      ProgressHUD.dismiss()
      showErrorAlert(message: error)
    case .loading:
      ProgressHUD.show(message: "Loading...")
    case .success:
      ProgressHUD.success("Save success!", withDelay: 0.5)
    }
  }
  
}
