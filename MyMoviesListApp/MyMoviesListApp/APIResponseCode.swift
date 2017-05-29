//
//  APIResponseCode.swift
//  MyMoviesListApp
//
//  Created by Rigoberto Sáenz Imbacuán on 5/29/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

enum APIResponseCode {
    case dataSaveError
    case missingParameterError
    case referenceError
    case connectionError
    case httpCodeError
    case parsingError
    case emptyJsonError
    case mappingError
    case success
}
