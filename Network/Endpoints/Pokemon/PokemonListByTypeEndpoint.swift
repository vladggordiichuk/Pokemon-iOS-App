//
//  PokemonListByTypeEndpoint.swift
//  Pokemon App
//
//  Created by Vlad Gordiichuk on 17.06.2020.
//  Copyright © 2020 Vlad Gordiichuk. All rights reserved.
//

import Foundation

struct PokemonListByTypeEndpoint: Decodable {
    
    let pokemons: [Pokemon]
    
    enum CodingKeys: String, CodingKey {
        case pokemon
    }
    
    enum PokemonCodingKeys: String, CodingKey {
        case name, url
    }
    
    init(from decoder: Decoder) throws {
        
        var pokemonList = [Pokemon]()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var listContainer = try container.nestedUnkeyedContainer(forKey: .pokemon)
        
        while !listContainer.isAtEnd {
            
            let pokemonContainer = try listContainer.nestedContainer(keyedBy: CodingKeys.self)
            let pokemonData = try pokemonContainer.nestedContainer(keyedBy: PokemonCodingKeys.self, forKey: .pokemon)
            let pokemonName = try pokemonData.decode(String.self, forKey: .name)
            
            guard
                let pokemonUrlString = try? pokemonData.decode(String.self, forKey: .url),
                let pokemonUrl = URL(string: pokemonUrlString),
                let pokemonId = Int(pokemonUrl.pathComponents.last ?? "-1"), pokemonId > 0
                else { continue }
            
            pokemonList.append(Pokemon(id: pokemonId, name: pokemonName))
        }
        
        pokemons = pokemonList
    }
}

extension EndpointCollection {
    
    static func getPokemonList(for kind: Pokemon.Kind) -> Endpoint {
        return Endpoint(method: .get, pathEnding: "type/\(kind.asRequestInt)")
    }
}
