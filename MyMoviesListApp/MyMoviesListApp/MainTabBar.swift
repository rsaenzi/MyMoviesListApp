//
//  MainTabBar.swift
//  MyMoviesListApp
//
//  Created by Rigoberto Sáenz Imbacuán on 5/27/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import UIKit

class MainTabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barStyle = .blackOpaque
        tabBar.items?.first?.title = LanguageString.popular.localize()
        tabBar.items?[1].title = LanguageString.search.localize()
    }
}
