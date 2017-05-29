//
//  GetDeviceCodeResponse.swift
//  MyMoviesListApp
//
//  Created by Rigoberto Sáenz Imbacuán on 5/29/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation
import ObjectMapper

struct GetDeviceCodeResponse {
    var deviceCode: String = ""
    var userCode: String = ""
    var verificationUrl: String = ""
    var expiresIn: Int = 0
    var interval: Int = 0
}

extension GetDeviceCodeResponse: Mappable {
    
    mutating func mapping(map: Map) {
        deviceCode      <- map[JsonKey.deviceCode.rawValue]
        userCode        <- map[JsonKey.userCode.rawValue]
        verificationUrl <- map[JsonKey.verificationUrl.rawValue]
        expiresIn       <- map[JsonKey.expiresIn.rawValue]
        interval        <- map[JsonKey.interval.rawValue]
    }
    
    init?(map: Map) {}
}

fileprivate enum JsonKey: String {
    case deviceCode = "device_code"
    case userCode = "user_code"
    case verificationUrl = "verification_url"
    case expiresIn = "expires_in"
    case interval = "interval"
}
