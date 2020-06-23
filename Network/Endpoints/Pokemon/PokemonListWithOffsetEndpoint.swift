//
//  PokemonListWithOffsetEndpoint.swift
//  Pokemon App
//
//  Created by Vlad Gordiichuk on 23.06.2020.
//  Copyright © 2020 Vlad Gordiichuk. All rights reserved.
//

import Foundation

struct PokemonListWithOffsetEndpoint: Decodable {
    
    let pokemons: [Pokemon]
    let total: Int
    
    enum CodingKeys: String, CodingKey {
        case results, total = "count"
    }
    
    enum PokemonCodingKeys: String, CodingKey {
        case name, url
    }
    
    init(from decoder: Decoder) throws {
        
        var pokemonList = [Pokemon]()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var listContainer = try container.nestedUnkeyedContainer(forKey: .results)
        
        while !listContainer.isAtEnd {
            
            let pokemonData = try listContainer.nestedContainer(keyedBy: PokemonCodingKeys.self)
            let pokemonName = try pokemonData.decode(String.self, forKey: .name)
            
            guard
                let pokemonUrlString = try? pokemonData.decode(String.self, forKey: .url),
                let pokemonUrl = URL(string: pokemonUrlString),
                let pokemonId = Int(pokemonUrl.pathComponents.last ?? "-1"), pokemonId > 0
                else { continue }
            
            pokemonList.append(Pokemon(id: pokemonId, name: pokemonName))
        }
        
        pokemons = pokemonList
        total = try container.decode(Int.self, forKey: .total)
    }
}

extension EndpointCollection {
    
    static func getPokemonList() -> Endpoint {
        return Endpoint(method: .get, pathEnding: "pokemon")
    }
}
