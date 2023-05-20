//
//  TableViewProvider.swift
//  ScrollViewProvider
//
//  Created by 杨雄凯 on 2023/5/19.
//

import UIKit
import SnapKit

// MARK: - 声明 + 默认实现

// UITableViewController无需使用此协议，如果一个页面只有一个tableView，还是建议使用系统的UITableViewController
public protocol TableViewProvider where Self: ScrollViewProvider & UITableViewDataSource & UITableViewDelegate {
    
    /// 提供初始化时tableView的style，默认plain
    func tableViewInitStyle() -> UITableView.Style
    
    /// 提供需要注册的cell类型集合
    func tableViewCells() -> [TableViewCellProvider]
    
    /// 提供需要注册的组头组尾，默认为空
    func tableViewSectionHeaderFooter() -> [TableViewSectionHeaderFooterProvider]
}

public extension TableViewProvider {
    
    func tableViewInitStyle() -> UITableView.Style { .plain }
    
    func tableViewSectionHeaderFooter() -> [TableViewSectionHeaderFooterProvider] { [] }
}

// MARK: - 外部

public extension TableViewProvider {
    
    var tableView: UITableView {
        if let t = table { return t }
        fatalError("请在viewDidLoad中执行initializeTableView方法")
    }
    
    /// 初始化tableView（遵守协议方写在viewDidLoad中）
    func initializeTableView() {
        if isRootView {
            // 本身根视图就是UITableView的情况，直接啥也不做，相当于没有遵守此协议
            return
        }
        
        let t: UITableView = make()
        
        let cells = tableViewCells()
        cells.forEach { t.register($0.type, forCellReuseIdentifier: $0.iden) }
        
        let headerFooters = tableViewSectionHeaderFooter()
        headerFooters.forEach { t.register($0.type, forHeaderFooterViewReuseIdentifier: $0.iden) }
        
        let fatherView = scrollViewSuperview()
        fatherView.addSubview(t)
        if let f = scrollViewFrame() {
            t.frame = f
        } else {
            t.snp.makeConstraints { make in
                make.edges.equalTo(scrollViewEdgeInsets())
            }
        }
    }
}

// MARK: - 私有

private extension TableViewProvider {
    
    var isRootView: Bool {
        if let _ = self as? UICollectionViewController {
            return true
        }
        return false
    }
    
    var table: UITableView? {
        if let self = self as? UITableViewController {
            // 本身根视图就是tableView了，直接return
            return self.tableView
        }
        
        return scrollViewSuperview().viewWithTag(kTableViewTag) as? UITableView
    }
    
    func make() -> UITableView {
        let table = UITableView(frame: .zero, style: tableViewInitStyle())
        table.delegate = self
        table.dataSource = self
        table.estimatedRowHeight = 200
        table.estimatedSectionFooterHeight = 0
        table.estimatedSectionHeaderHeight = 0
        table.rowHeight = UITableView.automaticDimension
        table.tag = kTableViewTag
        if #available(iOS 15.0, *) { table.sectionHeaderTopPadding = 0 }
        return table
    }
}

private let kTableViewTag: Int = 920917
