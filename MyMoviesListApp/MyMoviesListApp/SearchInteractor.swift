//
//  SearchInteractor.swift
//  MyMoviesListApp
//
//  Created by Rigoberto Sáenz Imbacuán on 5/28/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper

typealias SearchInteractorCallback = (_ keyword: String, _ timestamp: Date, _ movies: [SearchMovieResponse], _ code: APIResponseCode) -> Void
typealias GetBackImageCallback = (_ backImage: String, _ indexPath: IndexPath, _ code: APIResponseCode) -> Void

class SearchInteractor {
    
    func searchMovies(using keyword: String, at timestamp: Date, for page: Int, and pageItems: Int, callback: @escaping SearchInteractorCallback) {
        
        let provider = MoyaProvider<APIService>(endpointClosure: APIService.endpointClosure)
        provider.request(.getTextQueryResults(query: keyword, page: page, pageItems: pageItems)) { [weak self] result in
            
            guard let `self` = self else {
                callback(keyword, timestamp, [], .referenceError)
                return
            }
            
            switch result {
            case let .success(moyaResponse):
                self.handleSuccess(keyword, timestamp, moyaResponse, callback)
                
            case .failure(_):
                callback(keyword, timestamp, [], .connectionError)
                return
            }
        }
    }
    
    fileprivate func handleSuccess(_ keyword: String, _ timestamp: Date, _ response: Response, _ callback: SearchInteractorCallback) {
        
        var json: String = ""
        do {
            json = try response.mapString()
        } catch {
            callback(keyword, timestamp, [], .parsingError)
            return
        }
        
        guard response.statusCode == 200 else {
            callback(keyword, timestamp, [], .httpCodeError)
            return
        }
        
        guard json.characters.count > 0 else {
            callback(keyword, timestamp, [], .emptyJsonError)
            return
        }
        
        guard let movies: [SearchMovieResponse] = Mapper<SearchMovieResponse>().mapArray(JSONString: json) else {
            callback(keyword, timestamp, [], .mappingError)
            return
        }
        
        callback(keyword, timestamp, movies, .success)
    }
    
    func getImage(for movie: SearchMovieResponse, at indexPath: IndexPath, callback: @escaping GetBackImageCallback) {
        
        let provider = MoyaProvider<APIService>(endpointClosure: APIService.endpointClosure)
        provider.request(.getImage(imageId: movie.imdbId, apiKey: APICredentials.fanartTvProjectKey)) { [weak self] result in
            
            guard let `self` = self else {
                callback("", indexPath, .referenceError)
                return
            }
            
            switch result {
            case let .success(moyaResponse):
                self.handleSuccessGetImage(moyaResponse, indexPath, movie, callback)
                
            case .failure(_):
                callback("", indexPath, .connectionError)
                return
            }
        }
    }
    
    fileprivate func handleSuccessGetImage(_ response: Response, _ indexPath: IndexPath,
                                           _ movie: SearchMovieResponse, _ callback: GetBackImageCallback) {
        
        var json: String = ""
        do {
            json = try response.mapString()
        } catch {
            callback("", indexPath, .parsingError)
            return
        }
        
        guard response.statusCode == 200 else {
            callback("", indexPath, .httpCodeError)
            return
        }
        
        guard json.characters.count > 0 else {
            callback("", indexPath, .emptyJsonError)
            return
        }
        
        guard let result = ImagesResponse(JSONString: json) else {
            callback("", indexPath, .mappingError)
            return
        }
        
        let images: [String] = result.movieBackgrounds.map { banner in
            return banner.url
        }
        
        guard let backgroundImage = images.first else {
            callback("", indexPath, .dataSaveError)
            return
        }
        
        callback(backgroundImage, indexPath, .success)
    }
}
