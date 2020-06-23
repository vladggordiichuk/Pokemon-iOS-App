//
//  RequestOffset.swift
//  Pokemon App
//
//  Created by Vlad Gordiichuk on 23.06.2020.
//  Copyright © 2020 Vlad Gordiichuk. All rights reserved.
//

struct RequestOffset: Encodable {
    
    var page: Int = 0
    let limit: Int = 20
    var total: Int = -1
    
    var offset: Int { page * limit }
    
    var canPerformRequest: Bool {
        total == -1 || offset < total
    }
    
    enum CodingKeys: String, CodingKey {
        case offset = "offset"
        case limit
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(offset, forKey: .offset)
        try container.encode(limit, forKey: .limit)
    }
}
