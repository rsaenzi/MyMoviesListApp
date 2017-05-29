//
//  UILoader.swift
//  MyMoviesListApp
//
//  Created by Rigoberto Sáenz Imbacuán on 5/27/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation
import UIKit

class UILoader {
    
    static func loadScene<T: UIViewController>(from type: T.Type) -> T {
        
        // Get the screen name
        let name = className(some: type)
        
        // Load Storyboard
        let storyboard = UIStoryboard(name: name, bundle: nil)
        
        // Load ViewController an cast it
        guard let screen = storyboard.instantiateViewController(withIdentifier: name) as? T else {
            fatalError("No UIViewController with name \(name) was found")
        }
        return screen
    }
    
    private static func className(some: Any) -> String {
        return (some is Any.Type) ? "\(some)" : "\(type(of: some))"
    }
    
    static func loadCell<T: UITableViewCell>(from tableView: UITableView, for indexPath: IndexPath, from type: T.Type) -> T {
        
        let name = className(some: type)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: name, for: indexPath) as? T else {
            fatalError("No UITableViewCell with indentifier \(type) could be loaded")
        }
        return cell
    }
}
