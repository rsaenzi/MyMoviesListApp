//
//  LanguageString.swift
//  MyMoviesListApp
//
//  Created by Rigoberto Sáenz Imbacuán on 5/29/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation

enum LanguageString: String {
    case popular
    case search
    case searchPlaceholder
    
    func localize() -> String {
        let copy: String = NSLocalizedString(self.rawValue, tableName: nil, bundle: Bundle.main, value: "", comment: "")
        guard !copy.isEmpty else {
            return ""
        }
        return copy
    }
}
