//
//  ListViewController+UICollectionViewDelegate.swift
//  Pokemon App
//
//  Created by Vlad Gordiichuk on 23.06.2020.
//  Copyright © 2020 Vlad Gordiichuk. All rights reserved.
//

import UIKit

extension ListViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let pokemon = viewModel.collectionData?[indexPath.row] else { return }
        
        if pokemon.isCompletelyLoaded {
            let viewController = DetailsViewController(of: pokemon)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard
            kind == .all,
            let currentMaxRow = collectionView.indexPathsForVisibleItems.max(by: { $0.row < $1.row })?.row else { return }
        
        print(currentMaxRow, (viewModel.collectionData?.count ?? 0) - 4 )
        if currentMaxRow > (viewModel.collectionData?.count ?? 0) - 4 {
            viewModel.fetchPokemons()
        }
    }
}
