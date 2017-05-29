//
//  ImageBannerResponse.swift
//  MyMoviesListApp
//
//  Created by Rigoberto Sáenz Imbacuán on 5/29/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation
import ObjectMapper

struct ImageBannerResponse {
    var url: String = ""
}

extension ImageBannerResponse: Mappable {
    
    mutating func mapping(map: Map) {
        url <- map[JsonKey.url.rawValue]
    }
    
    init?(map: Map) {}
}

fileprivate enum JsonKey: String {
    case url
}
