//
//  PokemonCollectionCell+RxSwift.swift
//  Pokemon App
//
//  Created by Vlad Gordiichuk on 23.06.2020.
//  Copyright © 2020 Vlad Gordiichuk. All rights reserved.
//

import UIKit
import RxSwift
import SDWebImage

extension PokemonCollectionCell {
    
    internal func subscribeRx() {
        
        subscribeReceivedDataRx()
    }
    
    fileprivate func subscribeReceivedDataRx() {
        viewModel
        .receivedData
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] pokemon in
            
            self?.applyImageAndAbilities(with: URL(string: pokemon.imageUrl ?? ""), and: pokemon.abilitiesAsString, shouldShowImmediately: false)
            
        }).disposed(by: viewModel.disposeBag)
    }
}
