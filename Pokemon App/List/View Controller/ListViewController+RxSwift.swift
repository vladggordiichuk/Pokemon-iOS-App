//
//  ListViewController+RxSwift.swift
//  Pokemon App
//
//  Created by Vlad Gordiichuk on 23.06.2020.
//  Copyright © 2020 Vlad Gordiichuk. All rights reserved.
//

import RxSwift

extension ListViewController {
    
    internal func subscribeRx() {
        
        subscribeReceivedDataRx()
    }
    
    fileprivate func subscribeReceivedDataRx() {
        viewModel
        .receivedData
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] _ in
//            self?.collectionView.reloadData()
        }).disposed(by: viewModel.disposeBag)
    }
}
