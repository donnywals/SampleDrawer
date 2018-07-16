//
//  AppDelegate.swift
//  SampleDrawer
//
//  Created by Donny Wals on 16/07/2018.
//  Copyright © 2018 Donny Wals. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    let window = UIWindow()
    window.rootViewController = ViewController()
    window.makeKeyAndVisible()
    self.window = window

    return true
  }
}

