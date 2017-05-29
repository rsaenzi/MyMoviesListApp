//
//  PopularInteractor.swift
//  MyMoviesListApp
//
//  Created by Rigoberto Sáenz Imbacuán on 5/28/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper

typealias GetMoviesCallback = (_ movies: [PopularMovieResponse], _ code: APIResponseCode) -> Void
typealias GetImagesCallback = (_ images: [String], _ indexPath: IndexPath, _ code: APIResponseCode) -> Void

class PopularInteractor {
    
    func getMovies(for page: Int, and pageItems: Int, callback: @escaping GetMoviesCallback) {
        
        let provider = MoyaProvider<APIService>(endpointClosure: APIService.endpointClosure)
        provider.request(.getPopularMovies(page: page, pageItems: pageItems)) { [weak self] result in
            
            guard let `self` = self else {
                callback([], .referenceError)
                return
            }
            
            switch result {
            case let .success(moyaResponse):
                self.handleSuccessGetMovies(moyaResponse, callback)
                
            case .failure(_):
                callback([], .connectionError)
                return
            }
        }
    }
    
    fileprivate func handleSuccessGetMovies(_ response: Response, _ callback: GetMoviesCallback) {
        
        guard response.statusCode == 200 else {
            callback([], .httpCodeError)
            return
        }
        
        var json: String = ""
        do {
            json = try response.mapString()
        } catch {
            callback([], .parsingError)
            return
        }
        
        guard json.characters.count > 0 else {
            callback([], .emptyJsonError)
            return
        }
        
        guard let movies: [PopularMovieResponse] = Mapper<PopularMovieResponse>().mapArray(JSONString: json) else {
            callback([], .mappingError)
            return
        }
        
        callback(movies, .success)
    }
    
    func getImage(for imageId: String, at indexPath: IndexPath, callback: @escaping GetImagesCallback) {
        
        let provider = MoyaProvider<APIService>(endpointClosure: APIService.endpointClosure)
        provider.request(.getImage(imageId: imageId, apiKey: APICredentials.fanartTvProjectKey)) { [weak self] result in
            
            guard let `self` = self else {
                callback([], indexPath, .referenceError)
                return
            }
            
            switch result {
            case let .success(moyaResponse):
                self.handleSuccessGetImage(moyaResponse, indexPath, callback)
                
            case .failure(_):
                callback([], indexPath, .connectionError)
                return
            }
        }
    }
    
    fileprivate func handleSuccessGetImage(_ response: Response, _ indexPath: IndexPath, _ callback: GetImagesCallback) {
        
        var json: String = ""
        do {
            json = try response.mapString()
        } catch {
            callback([], indexPath, .parsingError)
            return
        }
        
        guard response.statusCode == 200 else {
            callback([], indexPath, .httpCodeError)
            return
        }
        
        guard json.characters.count > 0 else {
            callback([], indexPath, .emptyJsonError)
            return
        }

        guard let result = ImagesResponse(JSONString: json) else {
            callback([], indexPath, .mappingError)
            return
        }
        
        let images: [String] = result.movieBackgrounds.map { banner in
            return banner.url
        }
        
        callback(images, indexPath, .success)
    }
}
