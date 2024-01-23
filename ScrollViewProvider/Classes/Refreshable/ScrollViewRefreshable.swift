//
//  ScrollViewRefreshable.swift
//  ScrollViewProvider
//
//  Created by 杨雄凯 on 2023/5/19.
//

import UIKit
import MJRefresh

// 提供上拉加载下拉刷新的功能
public protocol Refreshable {
    
    /// 提供需要添加刷新功能的view
    /// - Returns: scrollView及其子类
    func refreshableView() -> UIScrollView
    
    /// 是否提供上拉加载功能（鉴于有的页面只需要下拉刷新而已），默认true
    /// - Returns: 开关
    func refreshableFooterEnable() -> Bool
    
    /// 下拉刷新
    func handleRefresh()
    
    /// 上拉加载
    func handleLoadMore()
    
    /// 是否需要一进入页面立即刷新，默认none
    func refreshImmediatelyMode() -> RefreshImmediatelyMode
}

public extension Refreshable {
    
    func refreshableFooterEnable() -> Bool { true }
    
    func refreshImmediatelyMode() -> RefreshImmediatelyMode { .none }
    
    /// 安装刷新控件（写在遵守者的viewDidLoad方法中）
    func initializeRefresh() {
        
        let scrollView = refreshableView()
        
        scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.handleRefresh()
        })
        scrollView.mj_header?.isAutomaticallyChangeAlpha = true
        
        if refreshableFooterEnable() {
            scrollView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
                self.handleLoadMore()
            })
            scrollView.mj_footer?.isAutomaticallyChangeAlpha = true
        }
        
        let mode = refreshImmediatelyMode()
        switch mode {
        case .forbidden:
            break
        case .none:
            handleRefresh()
        case .pull:
            scrollView.mj_header?.beginRefreshing()
        }
    }
    
    /// 手动出发刷新
    func refreshAnimateManual() {
        let scrollView = refreshableView()
        scrollView.mj_header?.beginRefreshing()
    }
    
    /// 停止所有刷新动作
    /// - Parameter noMoreData: 是否还有更多数据
    func stopRefreshing(noMoreData: Bool = false) {
        
        let scrollView = refreshableView()
        scrollView.mj_header?.endRefreshing()
        
        if noMoreData {
            scrollView.mj_footer?.endRefreshingWithNoMoreData()
        } else {
            scrollView.mj_footer?.endRefreshing()
            scrollView.mj_footer?.resetNoMoreData()
        }
    }
}

/// 进入页面立即刷新样式
public enum RefreshImmediatelyMode: Int {
    /// 禁止立即刷新
    case forbidden
    /// 立即刷新 + pull下拉动画
    case pull
    /// 立即刷新无动画
    case none
}

// 使用系统的下拉刷新

public protocol SystemRefreshable: UITableViewController {
    func handleRefresh() -> Selector
}

public extension SystemRefreshable {
    
    func initializeRefresh() {
        refreshControl = UIRefreshControl()
        
        let selector = handleRefresh()
        refreshControl?.addTarget(self, action: selector, for: .valueChanged)
        perform(selector)
    }
    
    func stopRefreshing() {
        refreshControl?.endRefreshing()
    }
}
