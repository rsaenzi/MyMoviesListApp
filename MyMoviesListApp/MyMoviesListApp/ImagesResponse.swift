//
//  ImagesResponse.swift
//  MyMoviesListApp
//
//  Created by Rigoberto Sáenz Imbacuán on 5/29/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation
import ObjectMapper

struct ImagesResponse {
    var movieBackgrounds: [ImageBannerResponse] = []
}

extension ImagesResponse: Mappable {
    
    mutating func mapping(map: Map) {
        movieBackgrounds <- map[JsonKey.movieBackgrounds.rawValue]
    }
    
    init?(map: Map) {}
}

fileprivate enum JsonKey: String {
    case movieBackgrounds = "moviebackground"
}
