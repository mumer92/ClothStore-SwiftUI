//
//  AppDelegate.swift
//  Clothes Store
//
//  Created by MuhammadUmer on 01/05/2021.
//  Copyright © 2021 MuhammadUmer. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var applicationCoordinator: ApplicationCoordinator?
    var coreDataStack = CoreDataStack(modelName: "ClothesStore")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupApplication()
        decorateGlobalInterface()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        coreDataStack.saveContext()
    }
    
    private func setupApplication() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let applicationCoordinator = ApplicationCoordinator(window: window)
        
        self.window = window
        self.applicationCoordinator = applicationCoordinator
        
        applicationCoordinator.start()
    }
    
    private func decorateGlobalInterface() {
        let navigationTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.primaryColour]
        
        UINavigationBar.appearance().largeTitleTextAttributes = navigationTitleAttributes
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().titleTextAttributes = navigationTitleAttributes
        UINavigationBar.appearance().tintColor = .primaryColour
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().isTranslucent = true
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().tintColor = .primaryColour
        UITabBar.appearance().backgroundColor = .white
        UITabBarItem.appearance().badgeColor = .primaryColour
        
        window?.overrideUserInterfaceStyle = .light
    }
}

