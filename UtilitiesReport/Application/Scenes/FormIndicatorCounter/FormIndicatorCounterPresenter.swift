//
//  FormIndicatorCounterPresenter.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 3/16/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

protocol FormIndicatorCounterPresenter: PresenterProtocol {
    var router: FormIndicatorCounterViewRouter { get set }
    func numberOfComponentsList() -> Int
    func numberOfRowsList(in componet: Int) -> Int
    func titleItemList(forRow row: Int, forComponent component: Int) -> String?
}

class FormIndicatorCounterPresenterImpl: FormIndicatorCounterPresenter {
    
    // MARK: preoeprty
    var router: FormIndicatorCounterViewRouter
    private weak var view: FormIndicatorCounterView?
    typealias Props = FormIndicatorCounterViewController.Props
    private var indicator: IndicatorsCounter
    private var userUntilitesCompany: UserUtilitiesCompany
    private var indicatorGateway: IndicatorsCouterGateway
    private var isNeedCounter: Bool {
        return userUntilitesCompany.company?.isNeedCounter ?? false
    }
    
    init(router: FormIndicatorCounterViewRouter,
         view: FormIndicatorCounterView?,
         indicator: IndicatorsCounter,
         userUntilitesCompany: UserUtilitiesCompany,
         indicatorGateway: IndicatorsCouterGateway) {
        self.router = router
        self.view = view
        self.indicator = indicator
        self.userUntilitesCompany = userUntilitesCompany
        self.indicatorGateway = indicatorGateway
    }
    
    // MARK: load methods
    func viewDidLoad() {
        presetProps(state: .edit)
    }
    
    private func presetProps(state: Props.PageState) {
        view?.props = generatorProps(state: state)
    }
    
    private func generatorProps(state: Props.PageState) -> Props {
        var indexSelected: (row: Int, component: Int)?
        if let counter = self.indicator.counter, isNeedCounter {
            if let index = userUntilitesCompany.counters.firstIndex(where: {$0.identifier == counter.identifier}) {
                indexSelected = (row: index, component: 0)
            }
        }
    
        return Props(
            date: Props.Field(
                name: "Date:",
                placeholder: nil,
                value: indicator.month,
                change: CommandWith(action: { [weak self] (date) in
                    self?.indicator.date = date ?? Date()
                }),
                state: .valid
            ),
            selectedDate: indicator.date,
            indicator: Props.Field(
                name: "Indicator of counter:",
                placeholder: nil,
                value: indicator.value,
                change: CommandWith(action: { [weak self] (text) in
                    self?.indicator.value = text ?? ""
                }),
                state: .valid
            ),
            counter: Props.Field(
                name: "Counter:",
                placeholder: nil,
                value: indicator.counter?.placeInstallation,
                change: CommandWith(action: { [weak self] (result) in
                    guard let `self` = self else { return }
                    if let index = result?.0, self.userUntilitesCompany.counters.count > index {
                        self.indicator.counter = self.userUntilitesCompany.counters[index]
                    }
                }),
                state: .valid
            ),
            isNeedCounter: isNeedCounter,
            selectedCounterItem: indexSelected,
            pageTitle: "Edit indicator of counter",
            state: state,
            buttonSaveTitle: "Save",
            commandSave: Command(action: actionSave)
        )
    }
    
    private func actionSave() {
        presetProps(state: .loading)
        if let message = checkValidFields() {
            presetProps(state: .falied(error: message))
        } else {
            saveIndicator()
        }
    }
    
    private func checkValidFields() -> String? {
        if indicator.value.isEmpty {
            return "Incorrect indicator of counter."
        }
        if isNeedCounter {
            if indicator.counter == nil {
                return "Is not selected counter."
            }
        }
        return nil
    }
    
    private func saveIndicator() {
        indicatorGateway.add(entity: indicator,
                             toUserCompanyID: userUntilitesCompany.accountNumber) { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success:
                self.presetProps(state: .success)
            case let .failure(error):
                self.presetProps(state: .falied(error: error.localizedDescription))
            }
        }
//        indicatorGateway.save(entity: indicator) { [weak self] (result) in
//            guard let `self` = self else { return }
//            switch result {
//            case .success:
//                self.presetProps(state: .success)
//            case let .failure(error):
//                self.presetProps(state: .falied(error: error.localizedDescription))
//            }
//        }
    }

    // MARK: list configure
    func numberOfComponentsList() -> Int {
        return 1
    }
    
    func numberOfRowsList(in componet: Int) -> Int {
        return userUntilitesCompany.counters.count
    }
    
    func titleItemList(forRow row: Int, forComponent component: Int) -> String? {
        let item = userUntilitesCompany.counters[row]
        return item.placeInstallation
    }
}
