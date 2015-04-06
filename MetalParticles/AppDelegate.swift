//
//  AppDelegate.swift
//  MetalParticles
//
//  Created by Simon Gladman on 17/01/2015.
//  Copyright (c) 2015 Simon Gladman. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication)
    {
        if let viewController = window?.rootViewController as? ViewController
        {
            viewController.isRunning = false
        }
    }

    func applicationDidEnterBackground(application: UIApplication)
    {
        if let viewController = window?.rootViewController as? ViewController
        {
            viewController.isRunning = false
        }
    }

    func applicationWillEnterForeground(application: UIApplication)
    {
        if let viewController = window?.rootViewController as? ViewController
        {
            viewController.isRunning = true
        }
    }

    func applicationDidBecomeActive(application: UIApplication)
    {
        if let viewController = window?.rootViewController as? ViewController
        {
            viewController.isRunning = true
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

