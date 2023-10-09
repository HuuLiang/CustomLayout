//
//  CLDecorationConfig.swift
//  
//
//  Created by 胡亮亮 on 2023/10/8.
//

import Foundation
import UIKit

public struct CLDecorationConfig {
    
    public struct Gradient {
        let size:CGSize
        let startPoint:CGPoint
        let endPoint:CGPoint
        let colors:[UIColor]
        let locations:[CGFloat]
        
        public init(size: CGSize, startPoint: CGPoint, endPoint: CGPoint, colors: [UIColor], locations: [CGFloat]) {
            self.size = size
            self.startPoint = startPoint
            self.endPoint = endPoint
            self.colors = colors
            self.locations = locations
        }
    }
    
    let backgroundColor:UIColor?
    let gradient:Gradient?
    let cornerRadius:CGFloat
    let cornerMask:CACornerMask
    
    public init(backgroundColor: UIColor? = nil,
         gradient:Gradient? = nil,
         cornerRadius:CGFloat = .zero,
         cornerMask:CACornerMask = [.layerMinXMinYCorner,
                                    .layerMaxXMinYCorner,
                                    .layerMinXMaxYCorner,
                                    .layerMaxXMaxYCorner]) {
        self.backgroundColor = backgroundColor
        self.gradient = gradient
        self.cornerRadius = cornerRadius
        self.cornerMask = cornerMask
    }
}
