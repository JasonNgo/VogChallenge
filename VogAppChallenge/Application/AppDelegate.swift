//
//  AppDelegate.swift
//  VogAppChallenge
//
//  Created by Jason Ngo on 2019-03-29.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var applicationCoordinator: ApplicationCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let applicationCoordinator = ApplicationCoordinator(window: window)
        
        self.window = window
        self.applicationCoordinator = applicationCoordinator
        
        applicationCoordinator.start()
        return true
    }
}

