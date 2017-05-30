//
//  APIService.swift
//  MyMoviesListApp
//
//  Created by Rigoberto Sáenz Imbacuán on 5/28/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation
import Moya
import SwiftKeychainWrapper

enum APIService {
    case getDeviceCode(clientId: String)
    case getToken(code: String, clientId: String, clientSecret: String)
    case refreshToken(refreshToken: String, clientId: String, clientSecret: String)
    case getPopularMovies(page: Int, pageItems: Int)
    case getTextQueryResults(query: String, page: Int, pageItems: Int)
    
    case getImage(imageId: String, apiKey: String)
}

extension APIService: TargetType {
    
    var baseURL: URL {
        switch self {
        case .getImage:
            return URL(string: "http://webservice.fanart.tv/v3")!
            
        default:
            return URL(string: "https://api.trakt.tv")!
        }}
    
    var path: String {
        switch self {
        case .getDeviceCode:
            return "/oauth/device/code"
            
        case .getToken:
            return "/oauth/device/token"
            
        case .refreshToken:
            return "/oauth/token"
            
        case .getPopularMovies:
            return "/movies/popular"
            
        case .getTextQueryResults:
            return "/search/movie"
            
        case .getImage(let imageId, _):
            return "/movies/\(imageId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getDeviceCode, .getToken, .refreshToken:
            return .post
            
        case .getPopularMovies, .getTextQueryResults, .getImage:
            return .get
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .getDeviceCode(let clientId):
            return ["client_id": clientId]
            
        case .getToken(let code, let clientId, let clientSecret):
            return ["code": code,
                    "client_id": clientId,
                    "client_secret": clientSecret]
            
        case .refreshToken(let refreshToken, let clientId, let clientSecret):
            return ["refresh_token": refreshToken,
                    "client_id": clientId,
                    "client_secret": clientSecret,
                    "grant_type": "refresh_token"]
            
        case .getPopularMovies(let page, let pageItems):
            return ["extended": "full",
                    "page": page,
                    "limit": pageItems]
            
        case .getTextQueryResults(let query, let page, let pageItems):
            return ["query": query,
                    "extended": "full",
                    "fields": "title",
                    "page": page,
                    "limit": pageItems]
            
        case .getImage( _, let apiKey):
            return ["api_key": apiKey]
        }
    }

    var parameterEncoding: ParameterEncoding {
        switch self {
        case .getDeviceCode, .getToken, .refreshToken:
            return JSONEncoding.default
            
        case .getPopularMovies, .getTextQueryResults, .getImage:
            return URLEncoding.default
        }
    }
    
    var sampleData: Data {
        return "".utf8Encoded
    }

    var task: Task {
        return .request
    }
}

extension APIService {
    
    static let endpointClosure = { (target: APIService) -> Endpoint<APIService> in
        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
        
        switch target {
            
        case .getPopularMovies, .getTextQueryResults:
            
            guard let accessToken: String = KeychainWrapper.standard.string(forKey: KeychainKey.apiAccessToken.rawValue),
                  let refreshToken: String = KeychainWrapper.standard.string(forKey: KeychainKey.apiRefreshToken.rawValue) else {
                    
                return defaultEndpoint
            }
            
            return defaultEndpoint.adding(newHTTPHeaderFields:
                ["trakt-api-key": APICredentials.traktClientId,
                 "trakt-api-version": "2",
                 "Authorization": "Bearer \(accessToken)"])
            
        default:
            return defaultEndpoint
        }
    }
}
