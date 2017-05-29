//
//  SearchView.swift
//  MyMoviesListApp
//
//  Created by Rigoberto Sáenz Imbacuán on 5/27/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import UIKit

class SearchView: UIViewController {
    
    var presenter: SearchPresenter!

    @IBOutlet weak var searchBarName: UISearchBar!
    @IBOutlet weak var tableViewMovies: UITableView!
    @IBOutlet weak var activityLoading: UIActivityIndicatorView!
    
    fileprivate var loadingData = false
    fileprivate var loadedPages = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarName.placeholder = LanguageString.searchPlaceholder.localize()
        
        activityLoading.clipsToBounds = true
        activityLoading.layer.cornerRadius = activityLoading.frame.size.height / 2
        activityLoading.isHidden = true
        
        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleViewTap(recognizer:)))
        viewTapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(viewTapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityLoading.isHidden = true
        searchBarName.becomeFirstResponder()
    }
    
    fileprivate func shouldLoadNextPage() {
        
        if loadingData == false {
            loadedPages += 1
            loadSearchedMovies(for: searchBarName.text)
        }
    }
    
    fileprivate func loadSearchedMovies(for searchString: String?) {
        
        guard let keyword = searchString else {
            loadingData = false
            activityLoading.isHidden = !loadingData
            return
        }
        
        print("Search: \(keyword)")
        
        guard keyword.trimmingCharacters(in: .whitespacesAndNewlines).characters.count > 0 else {
            loadingData = false
            activityLoading.isHidden = !loadingData
            return
        }
        
        guard keyword.characters.count > 1 else {
            loadingData = false
            activityLoading.isHidden = !loadingData
            return
        }
        
        loadingData = true
        activityLoading.isHidden = !loadingData
        
        presenter.getMovies(using: keyword.trimmingCharacters(in: .newlines), for: loadedPages) { _ in
            
            self.loadingData = false
            self.activityLoading.isHidden = !self.loadingData
            
            self.tableViewMovies.reloadData()
        }
    }
    
    func handleViewTap(recognizer: UIGestureRecognizer) {
        searchBarName.resignFirstResponder()
    }
}

extension SearchView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let validCell: CellSearchItem = cell as? CellSearchItem else {
            return
        }
        
        if validCell.imageBackground.image == nil {
            presenter.getImage(for: indexPath, of: tableView)
        }
        
        if (indexPath.row + 1) == presenter.searchResults.count {
            shouldLoadNextPage()
        }
    }
}

extension SearchView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return presenter.getCell(of:tableView, for:indexPath)
    }
}

extension SearchView: UISearchBarDelegate {
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        presenter.searchResults = []
        tableViewMovies.reloadData()
        
        loadedPages = 1
        
        loadSearchedMovies(for: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarName.resignFirstResponder()
    }
}
