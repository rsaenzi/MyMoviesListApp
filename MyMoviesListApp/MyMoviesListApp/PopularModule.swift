//
//  PopularModule.swift
//  MyMoviesListApp
//
//  Created by Rigoberto Sáenz Imbacuán on 5/27/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation

class PopularModule {
 
    var interactor: PopularInteractor
    var presenter: PopularPresenter
    var view: PopularView
    
    init() {
        
        interactor = PopularInteractor()
        
        presenter = PopularPresenter()
        presenter.interactor = interactor
        
        view = UILoader.loadScene(from: PopularView.self)
        view.presenter = presenter
    }
}
