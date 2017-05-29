//
//  AuthWireframe.swift
//  MyMoviesListApp
//
//  Created by Rigoberto Sáenz Imbacuán on 5/29/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class AuthWireframe {
    
    func goToLogin(_ window: UIWindow?, using presenter: AuthPresenter) {
        
        let view = UILoader.loadScene(from: AuthView.self)
        view.presenter = presenter
    
        window?.rootViewController = view
        window?.makeKeyAndVisible()
    }
    
    func goToMovies(_ window: UIWindow? = nil) {
        
        if let validWindow = window {
            showMovies(validWindow)
            return
        }
        
        if let validWindow = UIApplication.shared.windows.first {
            showMovies(validWindow)
            return
        }
    }
    
    fileprivate func showMovies(_ window: UIWindow) {
        
        let popularModule = PopularModule()
        let searchModule = SearchModule()
        
        let tabBar: MainTabBar = UILoader.loadScene(from: MainTabBar.self)
        tabBar.viewControllers = [popularModule.view, searchModule.view]
        
        window.rootViewController = tabBar
        window.makeKeyAndVisible()
    }
}
