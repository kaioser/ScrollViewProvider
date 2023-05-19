//
//  ScrollViewSearchable.swift
//  ScrollViewProvider
//
//  Created by 杨雄凯 on 2023/5/19.
//

import UIKit

// 使用前需要了解到的知识：
// 系统的搜索功能涉及到三个页面，分别是
// 1)【主页面】：发起搜索的页面，即搜索框所在的页面，通过当前页面的navigationItem设置的搜索框
// 2)【搜索页】：即UISearchController或其子类，一般此页面可以用来展示【热搜】or【搜索记录】等信息UI，值得注意的是，如果使用了子类化UISearchController的类，那么是无法展示出来【结果页】的
// 3)【结果页】：即searchBar文字改变或者点击键盘上的搜索按钮时展示出来的页面，表示搜索结果
//
// 如果点击搜索框时需要显示【搜索记录】或者【实时热搜】等这种页面时，一般情况下，为了页面逻辑清楚+代码分离
// 建议【结果页】单独分离出去一个和UISearchController无关的新页面，点击搜索按钮的时候跳转此页即可

// MARK: - 声明 + 默认实现

public protocol Searchable: UIViewController {
    
    /// 提供searchController
    /// - Returns: 默认返回pod内部便捷化声明的DefaultSearchController
    func searchController() -> UISearchController
    
    /// 添加搜索框所在的navigationItem
    /// - Returns: UINavigationItem
    func searchNavigationItem() -> UINavigationItem
    
    /// 搜索框占位文字，默认nil
    /// - Returns: 字符串
    func searchBarPlaceholder() -> String?
    
    /// 搜索框是否跟随scrollView滑动，默认false
    /// - Returns: Bool
    func searchBarHidesWhenScrolling() -> Bool
    
    /// 搜索结果页的显示时机，如果searchController未设置searchResultsController，那么此方法无效
    /// - Returns: 显示时机
    func searchResultsControllerDisplayMode() -> ResultsDisplayMode
    
    /// 搜索时，是否隐藏导航栏，默认为true
    /// - Returns: Bool
    func searchHidesNavigationBarDuringPresentation() -> Bool
    
    /// 搜索时，是否有灰色蒙版，默认为true
    /// - Returns: Bool
    func searchObscuresBackgroundDuringPresentation() -> Bool
}

public extension Searchable {
    
    func searchBarPlaceholder() -> String? { nil }
    
    func searchNavigationItem() -> UINavigationItem { navigationItem }
    
    func searchBarHidesWhenScrolling() -> Bool { false }
    
    func searchResultsControllerDisplayMode() -> ResultsDisplayMode { .showsWhenSearchBarIsActive }
    
    func searchHidesNavigationBarDuringPresentation() -> Bool { true }
    
    func searchObscuresBackgroundDuringPresentation() -> Bool { true }
}

// MARK: - 开放api

extension Searchable {
    
    public func initializeSearch() {
        // 如果searchBar是active的状态时push了新页面之后pop回来时有bug，那么看一下这个属性presentViewController
        // https://www.jianshu.com/p/b065413cbf57
        // definesPresentationContext = true
        
        let controller = searchController()
        controller.searchBar.placeholder = searchBarPlaceholder()
        controller.hidesNavigationBarDuringPresentation = searchHidesNavigationBarDuringPresentation()
        controller.obscuresBackgroundDuringPresentation = searchObscuresBackgroundDuringPresentation()// 此属性和dimsBackgroundDuringPresentation功能一样，但后者在iOS12之后被废弃了
        let mode = searchResultsControllerDisplayMode()
        
        if conforms(to: UISearchControllerDelegate.self) {
            controller.delegate = self as? any UISearchControllerDelegate// 响应的是searchController的生命周期
        }
        
        if conforms(to: UISearchResultsUpdating.self) && mode != .never {
            controller.searchResultsUpdater = self as? any UISearchResultsUpdating
        }
        
        if conforms(to: UISearchBarDelegate.self) {
            controller.searchBar.delegate = self as? any UISearchBarDelegate
        }
        
        if #available(iOS 13.0, *) {
            switch mode {
            case .never:
                // 此属性会直接暴力控制【结果页】的显示与否，如果为false，则automaticallyShowsSearchResultsController属性将无效
                controller.showsSearchResultsController = false
                
            case .showsWhenSearchBarIsActive:
                controller.showsSearchResultsController = true
                controller.automaticallyShowsSearchResultsController = false
                
            case .showsWhenSearchTextNotEmpty:
                controller.showsSearchResultsController = true
                controller.automaticallyShowsSearchResultsController = true
            }
        }
        
        let navItem = searchNavigationItem()
        navItem.searchController = controller
        navItem.hidesSearchBarWhenScrolling = searchBarHidesWhenScrolling()
    }
}

// MARK: - 其他

public enum ResultsDisplayMode {
    
    /// 永不展示【搜索结果页】
    case never
    
    /// SearchBar键盘弹出时立即显示【搜索结果页】
    case showsWhenSearchBarIsActive
    
    /// SearchBar输入文字不为空时显示【搜索结果页】
    case showsWhenSearchTextNotEmpty
}
