//
//  PTSelectable.swift
//  SelectedItemGroup
//
//  Created by Pengpingjun on 2020/12/4.
//

import Foundation

/// 可选元素
public protocol PTSelectableItem {
    var isSelected: Bool { get set }
    var tag: Int { get set }
}
/// 可选逻辑管理
public protocol PTSelectableManager {
    associatedtype T: PTSelectableItem
    /// maxSelectedNumber == 1时单选，>1时多选，不允许小于1
    var maxSelectedNumber: Int { get set }
    /// minSelectedNumber == 0 时，允许取消最后一个被选中的item
    var minSelectedNumber: Int { get set }
    /// 输入合法性检查
    func checkData(_ items: [T]) -> Bool
}
public extension PTSelectableManager {
    
    /// 输入合法性检查
    /// - Parameter items: 数据源
    /// - Returns: true：通过， false：未通过
    func checkData(_ items: [T]) -> Bool {
        guard !items.isEmpty else {
            debugPrint("list不能为空")
            return false
        }
        
        guard maxSelectedNumber >= 1 else {
            debugPrint("maxSelectedNumber不能小于1")
            return false
        }
        guard minSelectedNumber <= maxSelectedNumber else {
            debugPrint("minSelectedNumber不能大于maxSelectedNumber")
            return false
        }
        return true
    }
    
    /// 引用传递选中逻辑处理，修改原数组
    /// - Parameters:
    ///   - tag: 被选中元素的index
    ///   - items: 数据源
    func handleSelected(tag: Int, items: inout [T]) {
        // 输入合法性检查
        guard checkData(items) else {
            return
        }
        changeSelectedData(tag, &items)
    }
    
    /// 值传递选中逻辑处理，返回新数组
    /// - Parameters:
    ///   - tag: 被选中元素的index
    ///   - items: 数据源
    /// - Returns: 返回修改选中状态后的新数组
    func handleSelected(tag: Int, items: [T]) -> [T] {
        // 输入合法性检查
        guard checkData(items) else {
            return []
        }
        var items = items
        changeSelectedData(tag, &items)
        return items
    }

    /// 选中逻辑处理
    /// - Parameters:
    ///   - tag: 被选中元素的index
    ///   - items: 数据源引用
    func changeSelectedData(_ tag: Int, _ items: inout [T]) {
        let selectedArray = items.enumerated().filter { $0.element.isSelected == true }
        if maxSelectedNumber == 1 {
            // 单选
            if items[tag].isSelected, minSelectedNumber == 0 {
                items[tag].isSelected = false
            }
            if selectedArray.count <= 1 {
                items[tag].isSelected = true
                if let offset = selectedArray.first?.offset {
                    items[offset].isSelected = false
                }
            }
        } else {
            // 多选
            if items[tag].isSelected {
                if selectedArray.count > minSelectedNumber {
                    items[tag].isSelected = false
                }
            } else {
                if selectedArray.count < maxSelectedNumber {
                    items[tag].isSelected = true
                }
            }
        }
    }
    
}
