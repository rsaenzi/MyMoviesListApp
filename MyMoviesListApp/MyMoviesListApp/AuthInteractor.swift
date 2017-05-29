//
//  AuthInteractor.swift
//  MyMoviesListApp
//
//  Created by Rigoberto Sáenz Imbacuán on 5/29/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation
import Moya
import SwiftKeychainWrapper

typealias GetDeviceCodeCallback = (_ authInfo: GetDeviceCodeResponse?, _ code: APIResponseCode) -> Void
typealias GetTokenCallback = (_ success: Bool, _ code: APIResponseCode) -> Void

class AuthInteractor {
    
    fileprivate var deviceCodeInfo: GetDeviceCodeResponse?
    
    func hasSavedCredentials() -> Bool {
        
        guard let _: String = KeychainWrapper.standard.string(forKey: KeychainKey.apiAccessToken.rawValue),
              let _: String = KeychainWrapper.standard.string(forKey: KeychainKey.apiRefreshToken.rawValue) else {
                
            return false
        }
        
        return true
    }
    
    func getDeviceCode(using clientId: String, callback: @escaping GetDeviceCodeCallback) {
        
        deviceCodeInfo = nil
        
        let provider = MoyaProvider<APIService>(endpointClosure: APIService.endpointClosure)
        provider.request(.getDeviceCode(clientId: clientId)) { [weak self] result in
            
            guard let `self` = self else {
                callback(nil, .referenceError)
                return
            }
            
            switch result {
            case let .success(moyaResponse):
                self.handleSuccessDeviceCode(moyaResponse, callback)
                
            case .failure(_):
                callback(nil, .connectionError)
                return
            }
        }
    }
    
    fileprivate func handleSuccessDeviceCode(_ response: Response, _ callback: GetDeviceCodeCallback) {
        
        guard response.statusCode == 200 else {
            callback(nil, .httpCodeError)
            return
        }
        
        var json: String = ""
        do {
            json = try response.mapString()
        } catch {
            callback(nil, .parsingError)
            return
        }
        
        guard json.characters.count > 0 else {
            callback(nil, .emptyJsonError)
            return
        }
        
        guard let result = GetDeviceCodeResponse(JSONString: json) else {
            callback(nil, .mappingError)
            return
        }
        
        deviceCodeInfo = result
        callback(result, .success)
    }
    
    func getToken(callback: @escaping GetTokenCallback) {
        
        guard let info = deviceCodeInfo else {
            callback(false, .missingParameterError)
            return
        }
        
        let provider = MoyaProvider<APIService>(endpointClosure: APIService.endpointClosure)
        provider.request(.getToken(code: info.deviceCode,
                                   clientId: APICredentials.traktClientId,
                                   clientSecret: APICredentials.traktClientSecret)) { [weak self] result in
            
            guard let `self` = self else {
                callback(false, .referenceError)
                return
            }
            
            switch result {
            case let .success(moyaResponse):
                self.handleSuccessToken(moyaResponse, callback)
                
            case .failure(_):
                callback(false, .connectionError)
                return
            }
        }
    }
    
    fileprivate func handleSuccessToken(_ response: Response, _ callback: GetTokenCallback) {
        
        var json: String = ""
        do {
            json = try response.mapString()
        } catch {
            callback(false, .parsingError)
            return
        }
        
        guard response.statusCode == 200 else {
            callback(false, .httpCodeError)
            return
        }
        
        guard json.characters.count > 0 else {
            callback(false, .emptyJsonError)
            return
        }
        
        guard let result = GetTokenResponse(JSONString: json) else {
            callback(false, .mappingError)
            return
        }
        
        let saveAccessToken: Bool = KeychainWrapper.standard.set(result.accessToken, forKey: KeychainKey.apiAccessToken.rawValue)
        let saveRefreshToken: Bool = KeychainWrapper.standard.set(result.refreshToken, forKey: KeychainKey.apiRefreshToken.rawValue)
        
        guard saveAccessToken, saveRefreshToken else {
            callback(false, .dataSaveError)
            return
        }
        
        callback(true, .success)
    }
}
