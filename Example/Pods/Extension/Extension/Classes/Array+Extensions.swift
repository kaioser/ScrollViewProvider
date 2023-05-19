//
//  Array+Extensions.swift
//  Extension
//
//  Created by 杨雄凯 on 2023/5/19.
//

import Foundation

extension Array {
    /// 删除指定下标的元素并将其返回
    /// - Parameter indices: 下标集合
    /// - Returns: 已删除的元素
    mutating func removeSpecifiedIndices(_ indices: [Int]) -> [Element] {
        var arr: [Element] = []
        let sortedIndices = indices.sorted().reversed()
        for i in sortedIndices {
            guard i < count else { return [] }
            arr.append(remove(at: i))
        }
        return arr
    }
}

extension Array where Element: Hashable {
    
    /// 数组去重
    var unique: [Element] {
        
        var uniq = Set<Element>()
        uniq.reserveCapacity(self.count)
        
        return self.filter {
            return uniq.insert($0).inserted
        }
    }
}
