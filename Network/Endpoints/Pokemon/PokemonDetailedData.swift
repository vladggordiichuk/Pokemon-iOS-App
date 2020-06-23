//
//  PokemonDetailedData.swift
//  Pokemon App
//
//  Created by Vlad Gordiichuk on 19.06.2020.
//  Copyright © 2020 Vlad Gordiichuk. All rights reserved.
//

import Foundation

struct PokemonDetailedDataEndpoint: Decodable {
    
    let pokemon: Pokemon
    
    enum CodingKeys: String, CodingKey {
        case id, name, height, sprites, types, moves, abilities
    }
    
    enum SpritesCodingKeys: String, CodingKey {
        case `default` = "front_default"
    }
    
    enum TypesCodingKeys: String, CodingKey {
        case type, name
    }
    
    enum MovesCodingKeys: String, CodingKey {
        case move, name
    }
    
    enum AbilitiesCodingKeys: String, CodingKey {
        case ability, name
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        
        let height = try container.decode(Int.self, forKey: .height)
        
        let spritesContainer = try container.nestedContainer(keyedBy: SpritesCodingKeys.self, forKey: .sprites)
        let imageUrl = try spritesContainer.decodeIfPresent(String.self, forKey: .default)
        
        var types = [String]()
        var typeListContainer = try container.nestedUnkeyedContainer(forKey: .types)
        while !typeListContainer.isAtEnd {
            let typeContainer = try typeListContainer.nestedContainer(keyedBy: TypesCodingKeys.self)
            let typeData = try typeContainer.nestedContainer(keyedBy: TypesCodingKeys.self, forKey: .type)
            let type = try typeData.decode(String.self, forKey: .name)
            types.append(type)
        }
        
        var moves = [String]()
        var moveListContainer = try container.nestedUnkeyedContainer(forKey: .moves)
        while !moveListContainer.isAtEnd {
            let moveContainer = try moveListContainer.nestedContainer(keyedBy: MovesCodingKeys.self)
            let moveData = try moveContainer.nestedContainer(keyedBy: MovesCodingKeys.self, forKey: .move)
            let move = try moveData.decode(String.self, forKey: .name)
            moves.append(move)
        }
        
        var abilities = [String]()
        var abilityListContainer = try container.nestedUnkeyedContainer(forKey: .abilities)
        while !abilityListContainer.isAtEnd {
            let abilityContainer = try abilityListContainer.nestedContainer(keyedBy: AbilitiesCodingKeys.self)
            let abilityData = try abilityContainer.nestedContainer(keyedBy: AbilitiesCodingKeys.self, forKey: .ability)
            let ability = try abilityData.decode(String.self, forKey: .name)
            abilities.append(ability)
        }
        
        pokemon = Pokemon(id: id, name: name, imageUrl: imageUrl, height: height, types: types, moves: moves, abilities: abilities)
    }
}

extension EndpointCollection {
    static func getPokemon(for id: Int) -> Endpoint {
        return Endpoint(method: .get, pathEnding: "pokemon/\(id)")
    }
}
