//
//  PokemonCollectionCellViewModel.swift
//  Pokemon App
//
//  Created by Vlad Gordiichuk on 19.06.2020.
//  Copyright © 2020 Vlad Gordiichuk. All rights reserved.
//

import RxSwift
import RxCocoa
import Realm

final class PokemonCollectionCellViewModel {
    
    public let disposeBag = DisposeBag()
    
    public let receivedData = PublishSubject<Pokemon>()
    
    private var currentUrlTask: URLSessionTask?
    
    public func fetchDetails(_ pokemon: Pokemon) {
        
        cancelUrlTask()
        
        currentUrlTask = NetworkManager.shared.performRequest(to: EndpointCollection.getPokemon(for: pokemon.id.value ?? -1), with: EmptyRequest()) { [weak self] (result: Result<PokemonDetailedDataEndpoint>) in
            
            switch result {
            case .success(let data):
                RealmManager.add(objects: [pokemon])
                self?.receivedData.onNext(data.pokemon)
            case .failure(let error):
                guard error == .requestFailed else { return }
                self?.fetchDetails(pokemon)
            }
        }
    }
    
    public func cancelUrlTask() {
        currentUrlTask?.cancel()
        
    }
}

