//
//  CLDelegate.swift
//
//
//  Created by 胡亮亮 on 2023/10/8.
//

import UIKit

//MARK: Decoration
public protocol CLDelegate:UICollectionViewDelegateFlowLayout {
    
    func customLayout(_ customLayout:CustomLayout,sectionStyleAt section:Int) -> [CustomLayoutSectionStyle]
    
    ///item custom
    func analyzeCustomItems(attributes:inout [UICollectionViewLayoutAttributes],
                            itemSpacing:CGFloat,
                            lineSpacing:CGFloat,
                            inset:UIEdgeInsets,
                            maxY:inout CGFloat,
                            section:Int)
    
    func customLayoutDecorationConfig(at section:Int) -> CLDecorationConfig?

}

public extension CLDelegate {
    
    func customLayout(_ customLayout:CustomLayout,sectionStyleAt section:Int) -> [CustomLayoutSectionStyle] {
        return []
    }
    
    func analyzeCustomItems(attributes:inout [UICollectionViewLayoutAttributes],
                            itemSpacing:CGFloat,
                            lineSpacing:CGFloat,
                            inset:UIEdgeInsets,
                            maxY:inout CGFloat,
                            section:Int) {}
    
    func customLayoutDecorationConfig(at section:Int) -> CLDecorationConfig? {
        return .init(backgroundColor: .white, gradient: nil, cornerRadius: .zero)
    }

}
