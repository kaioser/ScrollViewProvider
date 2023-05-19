//
//  CollectionViewDraggable.swift
//  ScrollViewProvider
//
//  Created by 杨雄凯 on 2023/5/19.
//

import UIKit
import Extension

// MARK: - 声明

public protocol CollectionViewDraggable: UICollectionViewDragDelegate & UICollectionViewDropDelegate {
    
    associatedtype ModelType// 外部需要指定model类型
    typealias DraggableDataSource = [[ModelType]]// 二维数组
    
    /// 提供可实现拖拽功能的collectionView
    /// - Returns: 当前collectionView
    func draggableCollectionView() -> UICollectionView
    
    /// 拖动状态活跃时，是否支持动态添加cell
    /// - Returns: 布尔值
    func draggableCollectionViewAddable() -> Bool
}

// MARK: - 默认实现 + 初始化方法

public extension CollectionViewDraggable {
    
    /// 初始化拖拽功能
    /// - Parameter dragInteractionEnabled: 默认是否允许拖拽
    func initializeCollectionViewDraggable(_ dragInteractionEnabled: Bool) {
        let collectionView = draggableCollectionView()
        collectionView.dragInteractionEnabled = dragInteractionEnabled
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
    }
    
    func draggableCollectionViewAddable() -> Bool { true }
}

// MARK: - UICollectionViewDragDelegate

public extension CollectionViewDraggable where Self: UIViewController {
    
    // 官方文档:
    // 你必须实现这个方法以允许从你的集合视图中拖动项目。
    // 在你的实现中，为指定索引路径上的项目创建一个或多个UIDragItem对象。通常情况下，你只返回一个拖动项，但如果指定的项有子项或没有一个或多个关联项就不能拖动，也要包括这些项。
    // 当一个新的拖动在其范围内开始时，集合视图会调用此方法一次或多次。
    // 具体来说，如果用户从一个选定的项目开始拖动，集合视图会对属于选定的每个项目调用该方法一次。如果用户从一个未选择的项目开始拖动，集合视图只为该项目调用该方法一次。
    // 就是说如果有selected=true的cell，只要长按了一个，其他的也会同时drag
    func itemsForBeginning() -> [UIDragItem] {
        debugPrint("itemsForBeginning")
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
    
    // 官方文档:
    // 当你想让用户将项目添加到活动的拖动会话中时，实现此方法。
    // 如果你不实现这个方法，在集合视图中的轻敲会触发项目的选择或其他行为。
    // 然而，当拖动会话处于活动状态并发生轻击时，集合视图会调用此方法，让您有机会将基础项目添加到拖动会话中。
    // 在你的实现中，为指定索引路径处的项目创建一个或多个UIDragItem对象。
    // 通常情况下，你只返回一个拖动项，但如果指定的项有子项或没有一个或多个关联项就不能拖动，也要包括这些项。
    // 我的理解: 可以实现多个拖动，点击其他的cell可以加进来，就像桌面移动图标功能
    func itemsForAddingTo() -> [UIDragItem] {
        debugPrint("itemsForAddingTo")
        return draggableCollectionViewAddable() ? [UIDragItem(itemProvider: NSItemProvider())] : []
    }
    
    // 改变拖动过程中半透明状态的cell样式
    func dragPreviewParametersForItemAt() -> UIDragPreviewParameters {
        debugPrint("dragPreviewParametersForItemAt")
        return UIDragPreviewParameters()
    }
    
    // 返回一个布尔值，决定是否允许在拖动会话中进行移动操作。
    // 如果你不实现这个方法，默认的返回值是真。
    func dragSessionAllowsMoveOperation() -> Bool {
        debugPrint("dragSessionAllowsMoveOperation")
        return true
    }
    
    // 返回一个布尔值，确定拖动会话的源应用程序和目标应用程序是否必须相同。
    // 1.为true时，意为只能在本app内部进行拖拽；当前app(source app)发起的这个UIDragSession在其他app(destination app)上不响应，但是其他app会实时输出如下日志：
    // [EventDispatcher] Found no UIEvent for backing event of type: 11; contextId: 0xB2A6C83，就是系统检测到了有别的app中的拖拽来袭
    // 2.为false时，手势移动到其他app会响应其他app的dropSessionDidUpdate回调
    // 举例说明：
    // 若app1设置为false, 无论app2设置的是true还是false, app1发起的拖拽都可以在app2响应(app2会执行dropSessionDidUpdate回调)
    // 总结: 此方法只控制自己的拖拽能否在其他app中响应, 至于其他app是否愿意响应，则要看其他app的canHandleDropSession代理的返回值
    func dragSessionIsRestrictedToDraggingApplication() -> Bool {
        debugPrint("dragSessionIsRestrictedToDraggingApplication")
        return false
    }
    
    func dragSessionWillBegin() {
        debugPrint("dragSessionWillBegin")
    }
    
    func dragSessionDidEnd() {
        debugPrint("dragSessionDidEnd")
    }
}

// MARK: - UICollectionViewDropDelegate

public extension CollectionViewDraggable where Self: UIViewController {
    
    // 当你想动态地确定是否在你的集合视图中接受被拖动的数据时，实现这个方法。
    // 在你的实现中，检查被拖动的数据的类型，并返回一个布尔值，表示你是否可以接受掉落。
    // 例如，你可以调用会话对象的hasItemsConforming(toTypeIdentifiers:)方法来确定它是否包含你的应用程序可以接受的数据。
    // 如果你不实现这个方法，集合视图会假定返回值为true。
    // 如果你从这个方法中返回false，集合视图就不会再为给定的会话调用你的drop delegate的任何方法。
    func canHandle(_ session: UIDropSession) -> Bool {
        debugPrint("canHandle")
        // 可以使用此方法判断是否为【其他app】拖拽过来的数据类型，再决定是否处理这些数据
        //        if session.hasItemsConforming(toTypeIdentifiers: [UTType.image.identifier]) {
        //            return false
        //        }
        // toTypeIdentifiers必须用UTType
        // https://stackoverflow.com/questions/56894917/using-uidropinteractiondelegate-and-movies
        return session.localDragSession != nil// 只允许drop来自本app内部的drag
    }
    
    // 返回一个 UICollectionViewDropProposal 对象，告知 cell 该怎么送入新的位置。
    func dropSessionDidUpdate(_ session: UIDropSession, destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        debugPrint("dropSessionDidUpdate: \(destinationIndexPath?.description ?? "没有destinationIndexPath")")
        
        // Unspecified: 表示操作即将被拖放的视图, 但这个位置并不会以明确的方式显示出来
        // InsertAtDestinationIndexPath: 表示被拖放的视图会模拟最终放置效果, 也就是说会在目标位置离打开一个空白的地方来模拟最终插入的目标位置.
        // InsertIntoDestinationIndexPath: 表示将拖放的视图放置对应的索引中, 但这个位置并不会以明确的方式显示出来
        // 官方文档意义不够明确↓↓↓:
        // insertAtDestinationIndexPath: Insert the dropped items at the specified index path.
        // insertIntoDestinationIndexPath: Incorporate the dropped items into the item at the specified index path.
        
        if session.localDragSession == nil {
            
            // 拖动手势源自其它app。// https://juejin.cn/post/6844903517543497741
            // 其实这里肯定不会走了，因为上面的canHandle方法已经拒绝过一次了
            return UICollectionViewDropProposal(operation: .forbidden, intent: .unspecified)
            
        } else {
            // 拖动手势源自同一app。
            // 注意！！！！如果有多个dragItem，那么拖拽过程中不会打开一个空白位置来模拟插入，所以此时设置InsertAtDestinationIndexPath无效且不会响应performDropWith方法
            // 具体情况见回答和答案中的回复link：https://stackoverflow.com/questions/46488676/how-to-move-multiple-uitableview-rows-using-drag-drop-on-ios-11
            // 所以这里需要判断一下
            if session.items.count > 1 {
                // 多个drag，不能指定位置，只能靠程序员自己实现
                return UICollectionViewDropProposal(operation: .move, intent: .unspecified)
            }
            
            // 只有一个的时候，用苹果自带的UI效果
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
    }
    
    func dropSessionDidEnter() {
        debugPrint("dropSessionDidEnter")
    }
    
    // 当手指离开屏幕时，UICollectionView 会调用。必须实现该方法以接收拖动的数据
    // 使用这个方法来接受被丢弃的内容，并将其整合到你的集合视图中。
    // 在你的实现中，遍历协调者对象的项目属性，从每个UIDragItem中获取数据。
    // 将数据整合到你的集合视图的数据源中，并通过插入任何需要的项目来更新集合视图本身。
    // 纳入项目时，使用协调者对象的方法，将拖动项目的预览过渡到集合视图中的相应项目。
    // 对于你立即纳入的项目，你可以使用drop(_:to:)或drop(_:toItemAt:)方法来执行动画。
    func performDropWith(_ collectionView: UICollectionView, coordinator: UICollectionViewDropCoordinator, data: DraggableDataSource, callback: ((DraggableDataSource) -> Void)) {
        debugPrint("performDropWith")
        
        var newData = data
        
        switch coordinator.proposal.operation {
        case .move:
            
            guard let destinationIndexPath = coordinator.destinationIndexPath else {
                // 当拖拽到某一个section的尾部时，destinationIndexPath可能为nil
                return
            }
            debugPrint("-----destinationIndexPath: " + destinationIndexPath.description)
            
            // 拖拽的cell集合的indexPath集合
            let sourceIndexPaths = coordinator.items.compactMap { $0.sourceIndexPath }
            debugPrint("------sourceIndexPaths: " + sourceIndexPaths.description)
            
            if sourceIndexPaths.contains(destinationIndexPath) && coordinator.items.count > 1 {
                // 拖拽了多个cell但是没有拖拽到有效位置的时候，原路drop回去
                for dropItem in coordinator.items {
                    if let s = dropItem.sourceIndexPath {
                        coordinator.drop(dropItem.dragItem, toItemAt: s)
                    }
                }
                return
            }
            
            var models: [ModelType] = []
            let sectionIndexs = sourceIndexPaths.map { $0.section }.unique// 获取所有需要删除的model所在的section序号，并去重
            for sectionIndex in sectionIndexs {
                let indexPaths = sourceIndexPaths.filter { $0.section == sectionIndex }// 获取对应的section中的所有需要删除的indexPath
                let indices = indexPaths.map { $0.item }// 获取所在section数组的元素下标
                let removed = newData[sectionIndex].removeSpecifiedIndices(indices)// 一次性删除
                models.append(contentsOf: removed)// 删除完后临时保存一下
            }
            
            if coordinator.items.count == 1 {
                
                newData[destinationIndexPath.section].insert(contentsOf: models, at: destinationIndexPath.item)
                callback(newData)// collectionView自带的move、delete、insert等函数执行之前，一定要把数据源回调一下！！
                collectionView.moveItem(at: sourceIndexPaths.first!, to: destinationIndexPath)
                
                if let dp = coordinator.items.first {
                    coordinator.drop(dp.dragItem, toItemAt: destinationIndexPath)
                }
                
            } else {
                callback(newData)
                collectionView.deleteItems(at: sourceIndexPaths)
                
                var destinationIndexPaths: [IndexPath] = []
                for index in 0..<coordinator.items.count {
                    destinationIndexPaths.append(IndexPath(item: index, section: destinationIndexPath.section))
                }
                newData[destinationIndexPath.section].insert(contentsOf: models.reversed(), at: 0)
                callback(newData)
                collectionView.insertItems(at: destinationIndexPaths)
                                
                for (index, dropItem) in coordinator.items.enumerated() {
                    coordinator.drop(dropItem.dragItem, toItemAt: destinationIndexPaths[index])
                }
            }
            
        default:
            break
        }
    }
    
    func dropSessionDidEnd() {
        debugPrint("dropSessionDidEnd")
    }
    
    // 别的app的拖拽从本app中退出时调用
    func dropSessionDidExit() {
        debugPrint("dropSessionDidExit")
    }
    
    func dropPreviewParametersForItemAt() -> UIDragPreviewParameters {
        debugPrint("dropPreviewParametersForItemAt")
        return UIDragPreviewParameters()
    }
}
