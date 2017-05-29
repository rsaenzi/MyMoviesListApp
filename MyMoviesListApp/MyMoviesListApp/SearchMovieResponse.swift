//
//  SearchMovieResponse.swift
//  MyMoviesListApp
//
//  Created by Rigoberto Sáenz Imbacuán on 5/28/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation
import ObjectMapper

struct SearchMovieResponse {
    var type: String = ""
    var title: String = ""
    var year: Int = 0
    var traktId: Int64 = 0
    var slugId: String = ""
    var imdbId: String = ""
    var tmdbId: Int64 = 0
    var overview: String = ""
    
    var image: String = ""
}

extension SearchMovieResponse: Mappable {
    
    mutating func mapping(map: Map) {
        type    <- map[JsonKey.type.rawValue]
        title   <- map[JsonKey.title.rawValue]
        year    <- map[JsonKey.year.rawValue]
        traktId <- map[JsonKey.traktId.rawValue]
        slugId  <- map[JsonKey.slugId.rawValue]
        imdbId  <- map[JsonKey.imdbId.rawValue]
        tmdbId  <- map[JsonKey.tmdbId.rawValue]
        overview <- map[JsonKey.overview.rawValue]
    }
    
    init?(map: Map) {}
}

fileprivate enum JsonKey: String {
    case type
    case title = "movie.title"
    case year = "movie.year"
    case traktId = "movie.ids.trakt"
    case slugId = "movie.ids.slug"
    case imdbId = "movie.ids.imdb"
    case tmdbId = "movie.ids.tmdb"
    case overview = "movie.overview"
}
