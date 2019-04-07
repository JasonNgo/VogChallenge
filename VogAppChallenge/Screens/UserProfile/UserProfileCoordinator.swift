//
//  UserProfileCoordinator.swift
//  VogAppChallenge
//
//  Created by Jason Ngo on 2019-04-06.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

class UserProfileCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private var userProfileController: UserProfileTableViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
    
    override func start() {
        let userProfileController = UserProfileTableViewController(style: .grouped)
        userProfileController.title = "User Profile"
        setDeallocallable(with: userProfileController)
        navigationController.pushViewController(userProfileController, animated: false)
        self.userProfileController = userProfileController
    }
}
