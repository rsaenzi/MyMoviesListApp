//
//  GetTokenResponse.swift
//  MyMoviesListApp
//
//  Created by Rigoberto Sáenz Imbacuán on 5/29/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation
import ObjectMapper

struct GetTokenResponse {
    var accessToken: String = ""
    var tokenType: String = ""
    var expiresIn: Int = 0
    var refreshToken: String = ""
    var scope: String = ""
    var createdAt: Int64 = 0
}

extension GetTokenResponse: Mappable {
    
    mutating func mapping(map: Map) {
        accessToken  <- map[JsonKey.accessToken.rawValue]
        tokenType    <- map[JsonKey.tokenType.rawValue]
        expiresIn    <- map[JsonKey.expiresIn.rawValue]
        refreshToken <- map[JsonKey.refreshToken.rawValue]
        scope        <- map[JsonKey.scope.rawValue]
        createdAt    <- map[JsonKey.createdAt.rawValue]
    }
    
    init?(map: Map) {}
}

fileprivate enum JsonKey: String {
    case accessToken = "access_token"
    case tokenType = "token_type"
    case expiresIn = "expires_in"
    case refreshToken = "refresh_token"
    case scope = "scope"
    case createdAt = "created_at"
}
