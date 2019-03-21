//
//  UserFormPresenter.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/10/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol UserFormPresenter: PresenterProtocol {
    var router: UserFormViewRouter { get }
}

class UserFormPresenterImpl: UserFormPresenter {
    typealias Props = UserFormViewController.Props
    
    enum PresenterState {
        case initial
        case valid
    }

    // MARK: property
    fileprivate var userProfile: UserProfile!
    fileprivate weak var viewForm: UserFormView?
    fileprivate var isUserCreated: Bool = false
    fileprivate var saveUserProfileUseCase: SaveUserProfileUseCase!
    fileprivate var saveCommand: Command!
    fileprivate var itemsPropsValiad: [PartialKeyPath<UserProfile>: Props.ItemState] = [:]
    var router: UserFormViewRouter
    
    init(view: UserFormView,
         router: UserFormViewRouter,
         profile: UserProfile?,
         saveUserProfileUseCase: SaveUserProfileUseCase) {
        self.router = router
        self.viewForm = view
        self.saveUserProfileUseCase = saveUserProfileUseCase
        
        if let profile = profile {
            self.userProfile = profile
            isUserCreated = true
        } else {
            userProfile = UserProfile()
            isUserCreated = false
        }
        itemsPropsValiad = [:]
        saveCommand = Command(action: saveUserForm)
    }
    
    
    // MARK: UserFormPresenter methods
    func viewDidLoad() {
        presentProps()
    }
    
    private func presentProps(state: PresenterState = .initial, propsState: Props.PropsState = .edit) {
        viewForm?.props = generateProps(state: state, propsState: propsState)
    }

    // MARK: generate methods
    private func generateProps(state: PresenterState = .initial, propsState: Props.PropsState = .edit) -> Props {
        
        func generateItem(with key: PartialKeyPath<UserProfile>, name: String,
                          action: @escaping (String?) -> Void) -> Props.Item {
            let placeholder = "Enter \(name.lowercased())"
            let value = userProfile?[keyPath: key] as? String
            let command = CommandWith<String?>(action: { [weak self, key] changeValue in
                self?.itemsPropsValiad[key] = .valid
                action(changeValue)
            })
            let stateItem: Props.ItemState = state == .initial ? .valid : (itemsPropsValiad[key] ?? .valid)
            return Props.Item(name: name, value: value, placeholder: placeholder, change: command, state: stateItem)
        }

        return Props(
            firstName: generateItem(with: \UserProfile.firstName, name: "First Name",
                                    action: {[weak self] in self?.userProfile?.firstName = $0 ?? ""}),
            lastName: generateItem(with: \UserProfile.lastName, name: "Last Name",
                                   action: {[weak self] in self?.userProfile?.lastName = $0 ?? ""}),
            phoneNumber: generateItem(with: \UserProfile.phoneNumber, name: "Phone number",
                                      action: {[weak self] in self?.userProfile?.phoneNumber = $0 ?? ""}),
            email: generateItem(with: \UserProfile.email, name: "Email",
                                action: {[weak self] in self?.userProfile?.email = $0 ?? ""}),
            city: generateItem(with: \UserProfile.city, name: "City",
                               action: {[weak self] in self?.userProfile?.city = $0 ?? ""}),
            street: generateItem(with: \UserProfile.street, name: "Street",
                                 action: {[weak self] in self?.userProfile?.street = $0 ?? ""}),
            house: generateItem(with: \UserProfile.house, name: "House",
                                action: {[weak self] in self?.userProfile?.house = $0 ?? ""}),
            apartment: generateItem(with: \UserProfile.apartment, name: "Apartment",
                                    action: {[weak self] in self?.userProfile?.apartment = $0}),
            pageTitle: self.isUserCreated ? "Edit User" : "Create New User",
            saveButtonTitle: "Save",
            state: propsState,
            actionSave: self.saveCommand
        )
    }
    
    // MARK: change methods
    private func changeState(_ state: Props.PropsState) {
        viewForm?.props.state = state
    }
    
    private func changeProdsItem(with key: KeyPath<Props, Props.Item>,
                                 to writeKey: WritableKeyPath<Props, Props.Item>,
                                 state: Props.ItemState, value: String?) {
        
        let item = viewForm?.props[keyPath: key]
        viewForm?.props[keyPath: writeKey] = Props.Item(name: item?.name ?? "",
                                                        value: value,
                                                        placeholder: item?.placeholder ?? "",
                                                        change: item?.change ?? .nop,
                                                        state: state)
    }
    
    // MARK: check methods
    private func checkValidForm() -> Bool {
        var isValid: Bool = true
        
        userProfile.map {
            var firstNameState: Props.ItemState = .valid
            if $0.firstName.removeWhiteSpace().isEmpty {
               isValid = false
               firstNameState = .invalid(message: "Incorrect first name")
            }
            self.itemsPropsValiad[\UserProfile.firstName] = firstNameState
            
            var lastNameState: Props.ItemState = .valid
            if $0.lastName.removeWhiteSpace().isEmpty {
                isValid = false
                lastNameState = .invalid(message: "Incorrect last name")
            }
            self.itemsPropsValiad[\UserProfile.lastName] = lastNameState
            
            var phoneState: Props.ItemState = .valid
            if $0.phoneNumber.removeWhiteSpace().isEmpty || !$0.phoneNumber.isPhoneNumberValid {
                isValid = false
                phoneState = .invalid(message: "Incorrect phone number")
            }
            self.itemsPropsValiad[\UserProfile.phoneNumber] = phoneState
            
            var emailState: Props.ItemState = .valid
            if $0.email.removeWhiteSpace().isEmpty || !$0.email.isEmailValid {
                isValid = false
                emailState = .invalid(message: "Incorrect email")
            }
            self.itemsPropsValiad[\UserProfile.email] = emailState
            
            
            var cityState: Props.ItemState = .valid
            if $0.city.removeWhiteSpace().isEmpty {
                isValid = false
                cityState = .invalid(message: "Incorrect city")
            }
            self.itemsPropsValiad[\UserProfile.city] = cityState
            
            var streetState: Props.ItemState = .valid
            if $0.street.removeWhiteSpace().isEmpty {
                isValid = false
                streetState = .invalid(message: "Incorrect street")
            }
            self.itemsPropsValiad[\UserProfile.street] = streetState
            
            var houseState: Props.ItemState = .valid
            if $0.house.removeWhiteSpace().isEmpty {
                isValid = false
                houseState = .invalid(message: "Incorrect house")
            }
            self.itemsPropsValiad[\UserProfile.house] = houseState
        }
        return isValid
    }
    
    // MARK: actions
    func saveUserForm() {
        guard let state = viewForm?.props.state else { return }
        switch state {
        case .loading: return
        default:
            changeState(.loading)
            if checkValidForm() {
                saveFormContent()
            } else {
                 presentProps(state: .valid,
                              propsState: .falied(error: URError.incorrectProfileForm.localizedDescription))
            }
        }
      
    }
    
    private func saveFormContent() {
        saveUserProfileUseCase.save(user: userProfile) { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success:
                self.presentProps(state: .valid, propsState: .success)
                self.router.goToMainPage()
            case .failure(let error):
                self.presentProps(state: .valid,
                                  propsState: .falied(error: error.localizedDescription))
            }
        }
    }

}
