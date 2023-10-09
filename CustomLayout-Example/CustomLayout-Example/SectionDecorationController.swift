//
//  SectionDecorationController.swift
//  Example
//
//  Created by 胡亮亮 on 2023/10/8.
//

import UIKit
import CustomLayout

final class SectionDecorationController:UIViewController {
    
    fileprivate let cellIdf:String = "CustomCollectionCellIdf"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        collectionView.reloadData()
    }

    
    private lazy var collectionView:UICollectionView = { [unowned self] in
        let cl = CustomLayout()
        cl.delegate = self
        let cv = UICollectionView.init(frame: .init(x: 0,
                                                    y: 0,
                                                    width: kScreenWidth,
                                                    height: kScreenHeight), collectionViewLayout: cl)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .blue
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdf)
        view.addSubview(cv)
        return cv
    }()
}

extension SectionDecorationController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdf, for: indexPath)
        cell.contentView.backgroundColor = .brown
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 5, bottom: 20, right: 5)
    }
}


extension SectionDecorationController:CLDelegate {
    
//    func analyzeCustomItems(attributes: inout [UICollectionViewLayoutAttributes], itemSpacing: CGFloat, lineSpacing: CGFloat, inset: UIEdgeInsets, maxY: inout CGFloat, section: Int) {
//        
//    }
//    
    func customLayout(_ customLayout: CustomLayout, sectionStyleAt section: Int) -> [CustomLayoutSectionStyle] {
        if section == 1 {
            return [.sectionDecoration(.init(top: 0, left: 5, bottom: 20, right: 5))]
        }
        if section == 2 {
            return [.sectionDecoration(.init(top: 0, left: 0, bottom: 0, right: 0))]
        }
        if section == 4 {
            return [.sectionDecoration(.init(top: 0, left: 0, bottom: 0, right: 0))]
        }
        if section == 5 {
            return [.sectionDecoration(.init(top: 0, left: 0, bottom: 0, right: 0))]
        }
        return []
    }
    
    
    func customLayoutDecorationConfig(at section: Int) -> CLDecorationConfig? {
        if section == 1 {
            return CLDecorationConfig.init(backgroundColor: .red,
                                           cornerRadius: 0)
        }
        
        if section == 2 {
            return CLDecorationConfig.init(backgroundColor: .cyan,
                                           gradient: nil,
                                           cornerRadius: 20)
        }
        
        if section == 4 {
            return .init(gradient: .init(size: .init(width: Double.infinity,
                                                     height: Double.infinity),
                                         startPoint: .init(x: 0.5, y: 0),
                                         endPoint: .init(x: 0.5, y: 1),
                                         colors: [.yellow,.green],
                                         locations: [0,1]))
        }
        if section == 5 {
            return .init(gradient: .init(size: .init(width: Double.infinity,
                                                     height: Double.infinity),
                                         startPoint: .init(x: 0.5, y: 0),
                                         endPoint: .init(x: 0.5, y: 1),
                                         colors: [.clear,.white,.black],
                                         locations: [0,0.3,1]))
        }
        return nil
    }
    
    
    
}
