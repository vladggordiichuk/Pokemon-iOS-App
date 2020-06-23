//
//  ListViewController+UISearchBarDelegate.swift
//  Pokemon App
//
//  Created by Vlad Gordiichuk on 23.06.2020.
//  Copyright © 2020 Vlad Gordiichuk. All rights reserved.
//

import UIKit

extension ListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        pp = pp == 2 ? 1 : 2
//        UIView.animate(withDuration: 0.3) {
//            self.collectionView.setCollectionViewLayout(UICollectionViewFlowLayout(), animated: true)
//            self.collectionViewLayout.invalidateLayout()
//        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text, text != "" else { return }
        
//        viewModel.collectionData = viewModel.collectionData.filter({ $0.name?.range(of: text) != nil })
        collectionView.reloadData()
    }
}
