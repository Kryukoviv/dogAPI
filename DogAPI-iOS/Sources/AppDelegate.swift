//
//  AppDelegate.swift
//  DogAPI-iOS
//
//  Created by Igor Kryukov on 07.02.2021.
//  Copyright © 2021 Igor Kryukov. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = TabBarController()
		window?.makeKeyAndVisible()
		return true
	}

}

