//
//  ListView.swift
//  Pokemon App
//
//  Created by Vlad Gordiichuk on 14.06.2020.
//  Copyright © 2020 Vlad Gordiichuk. All rights reserved.
//

import UIKit

extension ListViewController {
    
    internal func configureBarsItem(_ kind: Pokemon.Kind) {
        
        tabBarItem.image = kind.asImage
        tabBarItem.title = kind.asLocalisedString
        
        navigationItem.title = String(format: "%@ Pokemons", kind.asLocalisedString)
    }
    
    internal func setUpElements() {
        
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(PokemonCollectionCell.self, forCellWithReuseIdentifier: PokemonCollectionCell.reuseIdentifier)
        
        collectionView.register(LoadingCollectionViewCell.self, forCellWithReuseIdentifier: LoadingCollectionViewCell.reuseIdentifier)
        collectionView.register(LoadingCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingCollectionViewCell.reuseIdentifier)
    }
}
