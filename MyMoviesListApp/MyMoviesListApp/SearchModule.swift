//
//  SearchModule.swift
//  MyMoviesListApp
//
//  Created by Rigoberto Sáenz Imbacuán on 5/27/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation

class SearchModule {
    
    var interactor: SearchInteractor
    var presenter: SearchPresenter
    var view: SearchView
    
    init() {
        
        interactor = SearchInteractor()
        
        presenter = SearchPresenter()
        presenter.interactor = interactor
        
        view = UILoader.loadScene(from: SearchView.self)
        view.presenter = presenter
    }
}
