//
//  MainConfiguration.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/9/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit.UITableView

protocol MainConfigurator {
  func configure(viewController: MainViewController)
}

class MainConfiguratorImpl: MainConfigurator {
  
  func configure(viewController: MainViewController) {
    let router = MainViewRouterImpl(viewController: viewController)
    let userProfileGateway = UserProfileGatewayImpl(api: FirebaseUserProfileGatewayImpl(),
                                                    storage: UserProfileLocalStorageGatewayImpl())
    let loadUserUseCase = LoadUserProfileUseCaseImpl(gateway: userProfileGateway)
    let storage = UserUtilCompanyLocalStorageGatewayImpl.default
    let userCompanyGateway = UserUtilitesCompanyGatewayImpl(localStorage: storage)
    let logoutUseCase = LogoutUseCaseImpl(gateway: AuthGatewayImpl(api: FirebaseAuthGatewayImpl(),
                                                                   storage: UserProfileLocalStorageGatewayImpl()))
    let presenter = MainPresenterImpl(view: viewController, router: router,
                                      loadUserProfile: loadUserUseCase,
                                      userCompanyGateway: userCompanyGateway,
                                      logoutUseCase: logoutUseCase)
    viewController.presenter = presenter
  }
}
