//
//  AuthPresenter.swift
//  MyMoviesListApp
//
//  Created by Rigoberto Sáenz Imbacuán on 5/29/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation
import UIKit

typealias DeviceCodeCallback = (_ code: String, _ url: String) -> Void

class AuthPresenter {
    
    var interactor: AuthInteractor!
    var wireframe: AuthWireframe!
    
    func loadFirstScene(_ window: UIWindow?) {
        if interactor.hasSavedCredentials() {
            wireframe.goToMovies(window)
        } else {
            wireframe.goToLogin(window, using: self)
        }
    }
    
    func getDeviceCode(completion: @escaping DeviceCodeCallback) {
        
        interactor.getDeviceCode(using: APICredentials.traktClientId) { info, responseCode in
            
            guard responseCode == .success else {
                completion("", "")
                return
            }
            
            guard let auth = info else {
                completion("", "")
                return
            }
            
            completion(auth.userCode, auth.verificationUrl)
        }
    }
    
    func getToken() {
        
        interactor.getToken { success, responseCode in
            
            guard success, responseCode == .success else {
                return
            }
            
            self.wireframe.goToMovies()
        }
    }
}
