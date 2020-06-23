//
//  PokemonCollectionCell.swift
//  Pokemon App
//
//  Created by Vlad Gordiichuk on 14.06.2020.
//  Copyright © 2020 Vlad Gordiichuk. All rights reserved.
//

import UIKit
import SDWebImage
import SkeletonView
import RealmSwift

final class PokemonCollectionCell: UICollectionViewCell {
    
    static let reuseIdentifier = "PokemonCollectionCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpElements()
        subscribeRx()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public weak var pokemon: Pokemon?
    
    internal var viewModel = PokemonCollectionCellViewModel()
    
    internal var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.isSkeletonable = true
        imageView.sd_imageTransition = .fade
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    internal var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    internal var abilitiesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        label.isSkeletonable = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        imageView.layoutSkeletonIfNeeded()
    }
    
    private func setUpElements() {
        
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        
        contentView.addSubview(imageView)
        
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(abilitiesLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            abilitiesLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            abilitiesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            abilitiesLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            abilitiesLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            abilitiesLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    public func fill(with pokemon: Pokemon) {
        
        self.pokemon = pokemon
        
        titleLabel.text = pokemon.name?.capitalized
        
        if pokemon.isCompletelyLoaded {
            
            applyImageAndAbilities(with: URL(string: pokemon.imageUrl ?? ""), and: pokemon.abilitiesAsString)
        } else {
            
            let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)

            imageView.showAnimatedGradientSkeleton(usingGradient: SkeletonAppearance.default.gradient, animation: animation)
            abilitiesLabel.showAnimatedGradientSkeleton(usingGradient: SkeletonAppearance.default.gradient, animation: animation)
            
            viewModel.fetchDetails(pokemon)
        }
    }
    
    internal func applyImageAndAbilities(with url: URL?, and abilities: String, shouldShowImmediately: Bool = true) {
        
        if let image = SDImageCache.shared.imageFromCache(forKey: url?.absoluteString) {
            
            imageView.image = image
            imageView.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(shouldShowImmediately ? 0 : 0.5))
        } else {
            
            let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)

            imageView.showAnimatedGradientSkeleton(usingGradient: SkeletonAppearance.default.gradient, animation: animation)
            
            imageView.sd_setImage(with: url, completed: { [weak self] (_, error, _, _) in
                
                if error != nil {
                    self?.imageView.image = UIImage(named: "no-image")
                    self?.imageView.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.5))
                } else {
                    self?.imageView.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.5))
                }
            })
        }
        
        abilitiesLabel.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(shouldShowImmediately ? 0 : 0.5))
        abilitiesLabel.text = abilities
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.sd_cancelCurrentImageLoad()
        viewModel.cancelUrlTask()
        
        imageView.image = nil
        abilitiesLabel.text = nil
    }
}
