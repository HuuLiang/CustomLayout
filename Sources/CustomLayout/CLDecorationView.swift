//
//  CLDecorationView.swift
//
//
//  Created by 胡亮亮 on 2023/10/8.
//

import Foundation
import UIKit

public class CLDecorationView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .gray
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        guard let attr = layoutAttributes as? CLDecorationAttributes else {
            return
        }
        
        backgroundColor = attr.backgroundColor
        
        if let gradient = attr.gradient {
            layer.sublayers?.forEach{$0.removeFromSuperlayer()}
            let width = gradient.size.width == .infinity ? frame.width : gradient.size.width
            let height = gradient.size.height == .infinity ? frame.height : gradient.size.height
            let gradientLayer = CAGradientLayer.create(size: .init(width: width, height: height),
                                                       colors: gradient.colors,
                                                       locations: gradient.locations,
                                                       direct: .customDirection(startPoint: gradient.startPoint,
                                                                                endPoint: gradient.endPoint))
            layer.insertSublayer(gradientLayer, at: 0)
        }
        
        if attr.cornerRadius != .zero {
            layer.cornerRadius = attr.cornerRadius
            layer.maskedCorners = attr.cornerMask
        }

    }
}

