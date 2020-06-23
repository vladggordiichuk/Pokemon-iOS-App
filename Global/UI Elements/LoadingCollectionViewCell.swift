//
//  LoadingCollectionViewCell.swift
//  Pokemon App
//
//  Created by Vlad Gordiichuk on 23.06.2020.
//  Copyright © 2020 Vlad Gordiichuk. All rights reserved.
//

import UIKit

final class LoadingCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "LoadingCollectionViewCell"

    private let loaderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 30),
            view.heightAnchor.constraint(equalToConstant: 30)
        ])
        view.backgroundColor = .lightGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        contentView.addSubview(loaderView)
        NSLayoutConstraint.activate([
            loaderView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            loaderView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if loaderView.backgroundColor != .clear {
            loaderView.backgroundColor = .clear
            
            loaderView.layer.addSublayer(baseLayer)
            loaderView.layer.addSublayer(circleLayer)
            
            loaderView.layer.add(animationForSpinLayer, forKey: "360")
        }
    }
    
    private var baseLayer: CAShapeLayer {
        let  baseLayer = CAShapeLayer()
        baseLayer.path = UIBezierPath(arcCenter: CGPoint(x: 15,
                                                         y: 15),
                                        radius: 15,
                                        startAngle: 0,
                                        endAngle: .pi * 2,
                                        clockwise: true).cgPath
        baseLayer.lineWidth = 5
        baseLayer.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.05)
        baseLayer.fillColor = UIColor.clear.cgColor
        
        return baseLayer
    }
    
    private var circleLayer: CAShapeLayer {
        let circleLayer = CAShapeLayer()
        circleLayer.path = UIBezierPath(arcCenter: CGPoint(x: 15,
                                                           y: 15),
                                        radius: 15,
                                        startAngle: 0,
                                        endAngle: .pi / 2.5,
                                        clockwise: true).cgPath
        circleLayer.lineWidth = 5
        circleLayer.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        
        return circleLayer
    }
    
    private var animationForSpinLayer: CABasicAnimation {
        let fullRotation = CABasicAnimation(keyPath: "transform.rotation")
        fullRotation.fromValue = NSNumber(floatLiteral: 0)
        fullRotation.toValue = NSNumber(floatLiteral: Double(CGFloat.pi * 2))
        fullRotation.duration = 2
        fullRotation.isRemovedOnCompletion = false
        fullRotation.repeatCount = .infinity
        return fullRotation
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        loaderView.layer.removeAllAnimations()
        loaderView.layer.add(animationForSpinLayer, forKey: "360")
    }
}

