//
//  SearchPresenter.swift
//  MyMoviesListApp
//
//  Created by Rigoberto Sáenz Imbacuán on 5/27/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation
import UIKit

typealias SearchPresenterCallback = (_ success: Bool) -> Void

class SearchPresenter {
    
    var interactor: SearchInteractor!
    var searchResults: [SearchMovieResponse] = []
    let itemsPerPage = 10
    
    func getCell(of tableView: UITableView, for indexPath: IndexPath) -> CellSearchItem {
        
        let cell: CellSearchItem = UILoader.loadCell(from: tableView, for: indexPath, from: CellSearchItem.self)
        
        let movie = searchResults[indexPath.row]
        cell.labelTitle.text = "\(movie.title) (\(movie.year))"
        cell.labelOverview.text = "\(movie.overview)"
        
        if movie.image.characters.count > 0 {
            cell.imageBackground.kf.setImage(with: URL(string: movie.image))
        } else {
            cell.imageBackground.image = nil
        }
        
        return cell
    }
    
    func getMovies(using keyword: String, for page: Int, completion: @escaping SearchPresenterCallback) {
        
        interactor.searchMovies(using: keyword, for: page, and: itemsPerPage) { [weak self] movies, responseCode in
            
            guard let `self` = self else {
                completion(false)
                return
            }
            
            guard movies.count > 0, responseCode == .success else {
                completion(false)
                return
            }
            
            self.searchResults.append(contentsOf: movies)
            completion(true)
        }
    }
    
    func getImage(for indexPath: IndexPath, of table: UITableView) {
        
        let movie = searchResults[indexPath.row]
        
        interactor.getImage(for: movie, at: indexPath) { image, index, responseCode in
            
            guard responseCode == .success else {
                return
            }
            
            guard let _ = table.cellForRow(at: index) as? CellSearchItem else {
                return
            }
            
            if index.row < self.searchResults.count {
                self.searchResults[index.row].image = image
                table.reloadRows(at: [index], with: .none)
            }
        }
    }
}
