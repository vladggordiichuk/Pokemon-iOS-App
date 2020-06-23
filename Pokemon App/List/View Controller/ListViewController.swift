//
//  ListViewController.swift
//  Pokemon App
//
//  Created by Vlad Gordiichuk on 14.06.2020.
//  Copyright © 2020 Vlad Gordiichuk. All rights reserved.
//

import UIKit
import SDWebImage
import RxSwift
import RealmSwift
final class ListViewController: UICollectionViewController {
    
    internal let kind: Pokemon.Kind
    
    init(of kind: Pokemon.Kind) {
        self.kind = kind
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
        configureBarsItem(kind)
        setUpElements()
        subscribeRx()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    private var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if kind == .all {
            viewModel.fetchPokemons()
        } else {
            
            viewModel.fetchPokemons(for: kind)
            
            self.navigationItem.searchController = UISearchController()
            self.definesPresentationContext = true
            self.navigationItem.searchController?.obscuresBackgroundDuringPresentation = false
            self.navigationItem.searchController?.searchResultsUpdater = self
            self.navigationItem.searchController?.searchBar.delegate = self
            
            
        }
        
        
        RealmManager.get(Pokemon.self) { [weak self] results in
            
            self?.viewModel.collectionData = results
            self?.notificationToken = self?.viewModel.collectionData?.observe { change in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch change {
                    case .initial: self.collectionView.reloadData()
                    case .error(let error): dump(error)
                    case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                        
                        self.collectionView.performBatchUpdates({
                            self.collectionView.deleteItems(at: deletions.compactMap {
                                if $0 < Int.max {
                                    return IndexPath(row: $0, section: 0)
                                } else {
                                    return nil
                                }
                            })
                            self.collectionView.insertItems(at: insertions.compactMap {
                                if $0 < Int.max {
                                    return IndexPath(row: $0, section: 0)
                                } else {
                                    return nil
                                }
                            })
                            self.collectionView.reloadItems(at: modifications.compactMap {
                                if $0 < Int.max {
                                    return IndexPath(row: $0, section: 0)
                                } else {
                                    return nil
                                }
                            })
                        })
                    }
                }
            }
        }
        
    }
    
    internal let viewModel = ListViewModel()
    
    var pp:CGFloat = 2
}
