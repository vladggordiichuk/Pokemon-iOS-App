//
//  ListViewModel.swift
//  Pokemon App
//
//  Created by Vlad Gordiichuk on 19.06.2020.
//  Copyright © 2020 Vlad Gordiichuk. All rights reserved.
//

import RxSwift
import RealmSwift

final class ListViewModel {
    
    public let disposeBag = DisposeBag()
    
    public var receivedData = PublishSubject<Bool>()
    
    private var offset = RequestOffset(page: 0)
    
    public var collectionData: Results<Pokemon>?
    
    private var isRequestForbidden = false
    
    // For global pokemon search with pagination.
    
    public func fetchPokemons(_ forceUpdate: Bool = false) {
        
        guard offset.canPerformRequest, (forceUpdate ? true : !isRequestForbidden) else { return }
        
        isRequestForbidden = true
        
        NetworkManager.shared.performRequest(to: EndpointCollection.getPokemonList(), with: offset) { [weak self] (result: Result<PokemonListWithOffsetEndpoint>) in
            
            switch result {
            case .success(let data):
                self?.offset.page += 1
                self?.offset.total = data.total
//                self?.receivedData.onNext(true)
                RealmManager.add(objects: data.pokemons)
                self?.isRequestForbidden = false
            case .failure(_): self?.fetchPokemons(true)
            }
        }
    }
    
    // For pokemon search by types. No pagination.
    
    public func fetchPokemons(for kind: Pokemon.Kind) {
        
        NetworkManager.shared.performRequest(to: EndpointCollection.getPokemonList(for: kind), with: EmptyRequest()) { [weak self] (result: Result<PokemonListByTypeEndpoint>) in
            
            switch result {
            case .success(let data):
//                self?.collectionData = data.pokemons
                self?.receivedData.onNext(true)
            case .failure(_): self?.fetchPokemons(for: kind)
            }
        }
    }
}
