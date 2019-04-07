//
//  ApplicationCoordinator.swift
//  VogAppChallenge
//
//  Created by Jason Ngo on 2019-04-06.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

class ApplicationCoordinator: Coordinator {
    private let window: UIWindow
    private let navigationController: UINavigationController
    private var userProfileCoordinator: UserProfileCoordinator?
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        self.navigationController.navigationBar.prefersLargeTitles = true
        super.init()
    }
    
    override func start() {
        window.rootViewController = navigationController
        userProfileCoordinator = UserProfileCoordinator(navigationController: navigationController)
        userProfileCoordinator?.stop = { [weak self] in
            self?.userProfileCoordinator = nil
        }
        userProfileCoordinator?.start()
        window.makeKeyAndVisible()
    }
}
