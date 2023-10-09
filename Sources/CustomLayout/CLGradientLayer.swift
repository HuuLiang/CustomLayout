//
//  CLGradientLayer.swift
//
//
//  Created by 胡亮亮 on 2023/10/8.
//

import CoreGraphics
import QuartzCore
import UIKit

public struct CLGradientDirectionPoint {
    let startPoint:CGPoint
    let endPoint:CGPoint
}

public enum CLGradientDirection {
    ///从上到下 ,
    case topToBottom
    ///从左到右
    case leftToRight
    ///从左上到右下
    case topLToBottomR
    
    ///custom
    case customDirection(startPoint:CGPoint,endPoint:CGPoint)
    
    func directPoint(rect:CGRect) -> CLGradientDirectionPoint {
        switch self {
        case .topToBottom:
            return .init(startPoint: .init(x: rect.origin.x + rect.width / 2.0, y: rect.origin.y),
                         endPoint: .init(x: (rect.origin.x + rect.width) / 2.0, y: rect.origin.y + rect.height))
        case .leftToRight:
            return .init(startPoint: .init(x: rect.origin.x, y: rect.origin.y + rect.height / 2.0),
                         endPoint: .init(x: rect.origin.x + rect.width, y: rect.origin.y + rect.height / 2.0))
        case .topLToBottomR:
            return .init(startPoint: rect.origin,
                         endPoint: .init(x: rect.origin.x + rect.width, y: rect.origin.y + rect.height))
        case let .customDirection(startPoint: startPoint, endPoint: endPoint):
            return .init(startPoint: startPoint,
                         endPoint: endPoint)
        }
    }
    
    var percentPoint:CLGradientDirectionPoint {
        switch self {
        case .topToBottom:
            return .init(startPoint: .init(x: 0.5, y: 0),
                         endPoint: .init(x: 0.5, y: 1))
        case .leftToRight:
            return .init(startPoint: .init(x: 0, y: 0.5),
                         endPoint: .init(x: 1, y: 0.5))
        case .topLToBottomR:
            return .init(startPoint: .zero,
                         endPoint: .init(x: 1, y: 1))
        case let .customDirection(startPoint: startPoint, endPoint: endPoint):
            return .init(startPoint: startPoint,
                         endPoint: endPoint)
        }
    }

}


extension CAGradientLayer {
    
    static func create(size:CGSize,
                       colors:[UIColor],
                       locations:[CGFloat] = [0,1],
                       direct:CLGradientDirection) -> CAGradientLayer {
        if colors.count != locations.count {
            fatalError("colors count must equal locations count")
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map({$0.cgColor})
        gradientLayer.locations = locations.map({NSNumber(value: Float($0))})
        gradientLayer.frame = .init(x: 0, y: 0, width: size.width, height: size.height)
        let directPoint = direct.percentPoint
        gradientLayer.startPoint = directPoint.startPoint
        gradientLayer.endPoint = directPoint.endPoint
        return gradientLayer
    }

}
