//
//  ViewController.swift
//  Example
//
//  Created by 胡亮亮 on 2023/10/8.
//

import UIKit
import Foundation


enum CellContent:String {
    case aaa
    case bbb
    case ccc
}

class ViewController: UIViewController {
    
    fileprivate let cellIdf:String = "CustomCellIdf"

    let list:[CellContent] = [.aaa,.bbb,.ccc]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.reloadData()
    }
    
    private lazy var tableView:UITableView = { [unowned self] in
        let tv = UITableView.init(frame: .init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight),
                                  style: .plain)
        tv.backgroundColor = .yellow
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: cellIdf)
        self.view.addSubview(tv)
        return tv
    }()

}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch list[indexPath.row] {
        case .aaa:
            let sdc = SectionDecorationController()
            sdc.modalPresentationStyle = .fullScreen
            present(sdc, animated: true)
        case .bbb:
            errSecUnimplemented
        case .ccc:
            errSecUnimplemented
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdf, for: indexPath) as UITableViewCell
//        cell.largeContentTitle = list[indexPath.row].rawValue
        cell.textLabel?.text = list[indexPath.row].rawValue
        return cell
    }
}
