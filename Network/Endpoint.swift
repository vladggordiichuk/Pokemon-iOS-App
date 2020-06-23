//
//  Endpoint.swift
//  Pokemon App
//
//  Created by Vlad Gordiichuk on 14.06.2020.
//  Copyright © 2020 Vlad Gordiichuk. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum Result<T> {
    case success(T)
    case failure(APIError)
}

struct Endpoint {
    var method: HTTPMethod
    var pathEnding: String
    
    init(method: HTTPMethod, pathEnding: String) {
        self.method = method
        self.pathEnding = pathEnding
    }
}

struct EndpointCollection { }
