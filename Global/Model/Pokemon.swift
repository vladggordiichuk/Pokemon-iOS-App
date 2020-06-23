//
//  PokemonType.swift
//  Pokemon App
//
//  Created by Vlad Gordiichuk on 14.06.2020.
//  Copyright © 2020 Vlad Gordiichuk. All rights reserved.
//

import UIKit
import RealmSwift

class Pokemon: Object {
    
    let id = RealmOptional<Int>()
    @objc dynamic var name: String?
    
    @objc dynamic var imageUrl: String?
    let height = RealmOptional<Int>()
    let types = List<String>()
    let moves = List<String>()
    let abilities = List<String>()
    
    var abilitiesAsString: String { abilities.joined(separator: ", ") }
    
    var isCompletelyLoaded: Bool {
        imageUrl != nil || height.value != nil || types.count != 0 || moves.count != 0 || abilities.count != 0
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init(id: Int, name: String, imageUrl: String? = nil, height: Int? = nil, types: [String]? = nil, moves: [String]? = nil, abilities: [String]? = nil) {
        
        self.init()
        
        self.id.value = id
        self.name = name
        
        self.imageUrl = imageUrl
        self.height.value = height
        self.types.append(objectsIn: types ?? [])
        self.moves.append(objectsIn: moves ?? [])
        self.abilities.append(objectsIn: abilities ?? [])
    }
    
    func applyData(_ pokemon: Pokemon) {
        
        RealmManager.update { [weak self] in
            
            self?.imageUrl = pokemon.imageUrl
            self?.height.value = pokemon.height.value
            self?.types.append(objectsIn: pokemon.types)
            self?.moves.append(objectsIn: pokemon.moves)
            self?.abilities.append(objectsIn: pokemon.abilities)
        }
    }
}

extension Pokemon {
    
    enum Kind: String {
        
        case all, ground, fire, water, flying
        
        var asLocalisedString: String {
            return self.rawValue.localizedCapitalized
        }
        
        var asImage: UIImage? {
            switch self {
            case .all: return UIImage(systemName: "square.grid.2x2")
            case .ground: return UIImage(systemName: "ant.circle")
            case .fire: return UIImage(systemName: "flame")
            case .water: return UIImage(systemName: "tropicalstorm")
            case .flying: return UIImage(systemName: "wind")
            }
        }
        
        var asRequestInt: Int {
            switch self {
            case .all: return -1
            case .ground: return 5
            case .fire: return 10
            case .water: return 11
            case .flying: return 3
            }
        }
    }
}
