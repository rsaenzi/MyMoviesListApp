//
//  AuthModule.swift
//  MyMoviesListApp
//
//  Created by Rigoberto Sáenz Imbacuán on 5/29/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation

class AuthModule {
    
    var wireframe: AuthWireframe
    var interactor: AuthInteractor
    var presenter: AuthPresenter
//    var view: AuthView
    
    init() {
        wireframe = AuthWireframe()
        
        interactor = AuthInteractor()
        
        presenter = AuthPresenter()
        presenter.wireframe = wireframe
        presenter.interactor = interactor
        
//        view = UILoader.loadScene(from: AuthView.self)
//        view.presenter = presenter
    }
}
