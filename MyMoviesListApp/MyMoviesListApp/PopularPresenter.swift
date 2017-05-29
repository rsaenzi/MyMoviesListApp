//
//  PopularPresenter.swift
//  MyMoviesListApp
//
//  Created by Rigoberto Sáenz Imbacuán on 5/27/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

typealias PopularPresenterCallback = (_ success: Bool) -> Void

class PopularPresenter {
    
    var interactor: PopularInteractor!
    var popularMovies: [PopularMovieResponse] = []
    let itemsPerPage = 10
    
    func getCell(of tableView: UITableView, for indexPath: IndexPath) -> CellPopularItem {
        
        let cell: CellPopularItem = UILoader.loadCell(from: tableView, for: indexPath, from: CellPopularItem.self)
        
        let movie = popularMovies[indexPath.row]
        cell.labelTitle.text = "\(movie.title) (\(movie.year))"
        cell.labelOverview.text = "\(movie.overview)"
        
        if movie.image.characters.count > 0 {
            cell.imageBackground.kf.setImage(with: URL(string: movie.image))
        } else {
            cell.imageBackground.image = nil
        }
        
        return cell
    }
    
    func getMovies(for page: Int, completion: @escaping PopularPresenterCallback) {
        
        interactor.getMovies(for: page, and: itemsPerPage) { [weak self] movies, responseCode in
            
            guard let `self` = self else {
                completion(false)
                return
            }
            
            guard movies.count > 0, responseCode == .success else {
                completion(false)
                return
            }
            
            self.popularMovies.append(contentsOf: movies)
            completion(true)
        }
    }
    
    func getImage(for indexPath: IndexPath, of table: UITableView) {
        
        let movie = popularMovies[indexPath.row]
        
        interactor.getImage(for: movie.imdbId, at: indexPath) { images, index, responseCode in
            
            guard responseCode == .success,
                let background = images.first else {
                return
            }
            
            if index.row < self.popularMovies.count {
                self.popularMovies[index.row].image = background
                table.reloadRows(at: [index], with: .none)
            }
        }
    }
}
