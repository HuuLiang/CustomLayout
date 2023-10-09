//
//  File.swift
//  
//
//  Created by 胡亮亮 on 2023/10/8.
//

import Foundation
import UIKit
import CoreGraphics


///section 布局风格
public enum CustomLayoutSectionStyle:Equatable {
    ///section 装饰图
    case sectionDecoration(_ inset:UIEdgeInsets = .zero)
    ///item 装饰图
    case itemDecoration
    ///流式标签
    case itemStream
    ///item custom
    case itemCustom
    
    public static func == (lhs:CustomLayoutSectionStyle,rhs:CustomLayoutSectionStyle) -> Bool {
        switch (lhs,rhs) {
        case (.sectionDecoration(_),sectionDecoration(_)):
            return true
        case (.itemDecoration,itemDecoration):
            return true
        case (.itemStream,itemStream):
            return true
        case (.itemCustom,itemCustom):
            return true
        default:return false
        }
    }
    
}


fileprivate extension UICollectionView {
    static let elementKindSectionDecoration: String = "UICollectionViewElementKindDecoration"
}

public class CustomLayout: UICollectionViewFlowLayout {
    
    public weak var delegate:CLDelegate!
    
    private var allAttirbutes:[UICollectionViewLayoutAttributes] = []
    private var maxY:CGFloat = 0
    
    public override init() {
        super.init()
        register(CLDecorationView.self, forDecorationViewOfKind: UICollectionView.elementKindSectionDecoration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepare() {
        super.prepare()
        
        calculate()
    }
    
    public override var collectionViewContentSize: CGSize {
        return .init(width: collectionView!.frame.width, height: maxY)
    }
    
    public override func invalidateLayout() {
        super.invalidateLayout()
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attris = allAttirbutes.filter {
            $0.frame.intersects(rect)
        }
        return attris
    }
    
    public override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attri = allAttirbutes.first(where: {$0.indexPath == indexPath}) else {
            return super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)
        }
        return attri
    }
        
    private final func calculate() {
        var _allAttirbutes:[UICollectionViewLayoutAttributes] = []
        maxY = 0
        for section in 0..<collectionView!.numberOfSections {
            
            let sectionStyles = delegate.customLayout(self, sectionStyleAt: section)
            
            let itemSpacing:CGFloat = delegate.collectionView?(collectionView!, layout: self, minimumInteritemSpacingForSectionAt: section) ?? 0
            let lineSpacing:CGFloat = delegate.collectionView?(collectionView!, layout: self, minimumLineSpacingForSectionAt: section) ?? 0
            let inset:UIEdgeInsets = delegate.collectionView?(collectionView!, layout: self, insetForSectionAt: section) ?? .zero
            let count = collectionView!.numberOfItems(inSection: section)
            
            //header
            if let headerAttri = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                      at: .init(item: 0, section: section))?.copy() as? UICollectionViewLayoutAttributes ,
               headerAttri.frame.size != .zero {
                headerAttri.frame = .init(x: headerAttri.frame.minX, y: maxY, width: headerAttri.frame.width, height: headerAttri.frame.height)
                _allAttirbutes.append(headerAttri)
                maxY = headerAttri.frame.maxY
            }
            
            //section inset top
            maxY += inset.top
            
            var sectionAttris:[UICollectionViewLayoutAttributes] = []
            for item in 0..<count {
                guard let attri = layoutAttributesForItem(at: .init(item: item, section: section))?.copy() as? UICollectionViewLayoutAttributes else {
                    continue
                }
                sectionAttris.append(attri)
            }
            
            //cell
            if !sectionAttris.isEmpty {
                if sectionStyles.contains(.itemStream) {
                    analyzeStreamItems(attributes: &sectionAttris,
                                       itemSpacing: itemSpacing,
                                       lineSpacing:lineSpacing,
                                       inset: inset,
                                       maxY: &maxY)
                } else if sectionStyles.contains(.itemCustom) {
                    analyzeCustomItems(attributes: &sectionAttris,
                                       itemSpacing: itemSpacing,
                                       lineSpacing: lineSpacing,
                                       inset: inset,
                                       maxY: &maxY,
                                       section: section)
                } else {
                    analyzeNormalItems(with: &sectionAttris,maxY: &maxY,inset: inset)
                }
                
                sectionAttris.forEach {
                    _allAttirbutes.append($0)
                }
            } else {
                //section inset bottom
                maxY += inset.bottom
            }
            
            //footer
            if let footerAttri = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                                      at: .init(item: 0, section: section))?.copy() as? UICollectionViewLayoutAttributes,
               footerAttri.frame.size != .zero {
                footerAttri.frame = .init(x: footerAttri.frame.minX, y: maxY, width: footerAttri.frame.width, height: footerAttri.frame.height)
                _allAttirbutes.append(footerAttri)
                maxY = footerAttri.frame.maxY
            }
            
            //decoration
            if let style = sectionStyles.first(where: {$0 == .sectionDecoration()}) {
                switch style {
                case .sectionDecoration(let decorationInset):
                    let _firstFrame:CGRect = sectionAttris.first?.frame ?? .zero
                    let width:CGFloat = collectionView!.frame.maxX - inset.right - inset.left
                    let _lastFrame:CGRect = sectionAttris.last?.frame ?? .zero
                    let unionFrame:CGRect = .init(x: _firstFrame.minX,
                                                  y: _firstFrame.minY,
                                                  width: width,
                                                  height: _lastFrame.maxY - _firstFrame.minY)
                    if let decorationAttri = analyzeSectionDecoration(union: unionFrame,
                                                                      inset: inset,
                                                                      decorationInset: decorationInset,
                                                                      section: section) {
                        _allAttirbutes.append(decorationAttri)
                    }
                default:
                    break
                }
            }
        }
        allAttirbutes = _allAttirbutes
    }
    
}


extension CustomLayout {
    
    ///CustomLayoutSectionStyle itemStream
    private final func analyzeStreamItems(attributes:inout [UICollectionViewLayoutAttributes],
                                          itemSpacing:CGFloat,
                                          lineSpacing:CGFloat,
                                          inset:UIEdgeInsets,
                                          maxY:inout CGFloat) {
        var newAttributes:[UICollectionViewLayoutAttributes] = []
        var lastFrame:CGRect!
        let fullWidth = collectionView!.frame.width
        for attri in attributes {
            if lastFrame == nil {
                attri.frame = .init(x: inset.left, y: maxY, width: attri.frame.width, height: attri.frame.height)
                lastFrame = attri.frame
                newAttributes.append(attri)
                continue
            }
            //获取预期宽度
            let width = lastFrame.maxX + itemSpacing + attri.frame.width + inset.right
            //判断是否需要换行
            if width > fullWidth {
                //需要换行
                attri.frame = .init(x: inset.left,
                                    y: lastFrame.maxY + lineSpacing,
                                    width: attri.frame.width,
                                    height: attri.frame.height)
                lastFrame = attri.frame
            } else {
                //不需要换行
                attri.frame = .init(x: lastFrame.maxX + itemSpacing,
                                    y: lastFrame.minY,
                                    width: attri.frame.width,
                                    height: attri.frame.height)
                lastFrame = attri.frame
            }
            newAttributes.append(attri)
        }
        maxY = lastFrame.maxY + inset.bottom
        attributes = newAttributes
    }
    
    ///CustomLayoutSectionStyle itemCustom
    private final func analyzeCustomItems(attributes:inout [UICollectionViewLayoutAttributes],
                                          itemSpacing:CGFloat,
                                          lineSpacing:CGFloat,
                                          inset:UIEdgeInsets,
                                          maxY:inout CGFloat,
                                          section:Int) {
        delegate.analyzeCustomItems(attributes: &attributes,
                                    itemSpacing: itemSpacing,
                                    lineSpacing: lineSpacing,
                                    inset: inset,
                                    maxY: &maxY,
                                    section: section)
    }
    
    ///CustomLayoutSectionStyle sectionDecoration
    private final func analyzeSectionDecoration(union frame:CGRect,
//                                                itemSpacing:CGFloat,
//                                                lineSpacing:CGFloat,
                                                inset:UIEdgeInsets,
                                                decorationInset:UIEdgeInsets,
                                                section:Int) -> UICollectionViewLayoutAttributes? {
        let attri = CLDecorationAttributes(decorationIdf: UICollectionView.elementKindSectionDecoration,with: section)
        
        let decorationConfig = delegate.customLayoutDecorationConfig(at: section)
        attri.backgroundColor = decorationConfig?.backgroundColor
        attri.gradient = decorationConfig?.gradient
        attri.cornerRadius = decorationConfig?.cornerRadius ?? .zero
        attri.cornerMask = decorationConfig?.cornerMask ?? [.layerMinXMinYCorner,
                                                            .layerMaxXMinYCorner,
                                                            .layerMinXMaxYCorner,
                                                            .layerMaxXMaxYCorner]
        attri.zIndex = -1
        
        var sectionFrame:CGRect = .zero
        
        if self.scrollDirection == .horizontal {
            //FIXME: errSecUnimplemented
            sectionFrame.origin.x = frame.minX - inset.left
            sectionFrame.origin.y = frame.minY - inset.top
            sectionFrame.size.width = frame.width + inset.left + inset.right
            sectionFrame.size.height = self.collectionView!.frame.height
        } else {
            // 先还原inset范围 再计算 decorationInset
            sectionFrame.origin.x = frame.minX - inset.left + decorationInset.left
            sectionFrame.origin.y = frame.minY - inset.top + decorationInset.top
            sectionFrame.size.width = frame.maxX + inset.right - decorationInset.right - sectionFrame.minX
            sectionFrame.size.height = frame.maxY + inset.bottom - decorationInset.bottom - sectionFrame.minY
        }
        attri.frame = sectionFrame
        
        return attri
    }
    
    ///CustomLayoutSectionStyle normal
    private final func analyzeNormalItems(with attributes:inout [UICollectionViewLayoutAttributes],maxY:inout CGFloat,inset:UIEdgeInsets) {
        let distance = attributes.first!.frame.minY - maxY
        var newAttributes:[UICollectionViewLayoutAttributes] = []
        for attri in attributes {
            attri.frame = .init(x: attri.frame.minX, y: attri.frame.minY - distance, width: attri.frame.size.width, height: attri.frame.size.height)
            newAttributes.append(attri)
        }
        maxY = newAttributes.last!.frame.maxY + inset.bottom
        attributes = newAttributes
    }
    
}

fileprivate extension UICollectionViewLayoutAttributes {
    
    convenience init(decorationIdf decorationViewKind: String, with section: Int) {
        self.init(forDecorationViewOfKind: decorationViewKind, with: .init(item: -1, section: section))
    }

}
