//
//  PopularView.swift
//  MyMoviesListApp
//
//  Created by Rigoberto Sáenz Imbacuán on 5/27/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import UIKit
import KVNProgress

class PopularView: UIViewController {
    
    var presenter: PopularPresenter!
    
    @IBOutlet weak var tableViewMovies: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var activityLoading: UIActivityIndicatorView!
    
    fileprivate var loadingData = false
    fileprivate var loadedPages = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.topItem?.title = LanguageString.popular.localize()
        activityLoading.layer.cornerRadius = activityLoading.frame.size.height / 2
        activityLoading.isHidden = true
        
        loadMovies()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityLoading.isHidden = true
    }
    
    fileprivate func shouldLoadNextPage() {
        
        if loadingData == false {
            loadedPages += 1
            loadMovies()
        }
    }
    
    fileprivate func loadMovies() {
        
        loadingData = true
        activityLoading.isHidden = !loadingData
        
        presenter.getMovies(for: loadedPages) { _ in
            
            self.loadingData = false
            self.activityLoading.isHidden = !self.loadingData
            
            self.tableViewMovies.reloadData()
        }
    }
}

extension PopularView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let validCell: CellPopularItem = cell as? CellPopularItem else {
            return
        }
        
        if validCell.imageBackground.image == nil {
            presenter.getImage(for: indexPath, of: tableView)
        }
        
        if (indexPath.row + 1) == presenter.popularMovies.count {
            shouldLoadNextPage()
        }
    }
}

extension PopularView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.popularMovies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return presenter.getCell(of:tableView, for:indexPath)
    }
}
