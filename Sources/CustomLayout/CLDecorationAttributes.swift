//
//  CLDecorationAttributes.swift
//
//
//  Created by 胡亮亮 on 2023/10/8.
//

import Foundation
import UIKit

/// section卡片装饰图的布局属性
open class CLDecorationAttributes: UICollectionViewLayoutAttributes {

    //背景色
    var backgroundColor:UIColor?
    
    ///渐变色图层
    var gradient:CLDecorationConfig.Gradient?
    
    var cornerRadius:CGFloat = 0
    
    var cornerMask:CACornerMask = [.layerMinXMinYCorner,
                                   .layerMaxXMinYCorner,
                                   .layerMinXMaxYCorner,
                                   .layerMinXMaxYCorner]

    //所定义属性的类型需要遵从 NSCopying 协议
    open override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! CLDecorationAttributes
        copy.backgroundColor = backgroundColor
        copy.gradient = gradient
        copy.cornerRadius = cornerRadius
        copy.cornerMask = cornerMask
        return copy
    }

    //所定义属性的类型还要实现相等判断方法（isEqual）
    open override func isEqual(_ object: Any?) -> Bool {
        guard object is CLDecorationAttributes else {
            return false
        }
        
        return super.isEqual(object)
    }
}
