//
//  Maxtrix.swift
//  ImageMatrix
//
//  Created by gavinning on 2018/3/31.
//  Copyright © 2018年 gavinning. All rights reserved.
//

import UIKit

public struct Matrix<T: Equatable> {
    // 矩阵元素
    private let items: Array<T>
    // 对外只读 记录矩阵
    public private(set) var grid = Array<[T]>()
    // 对外只读 记录列数
    public private(set) var columns: Int = 0 {
        didSet {
            self.layout()
        }
    }
    // 根据生成的矩阵计算行数
    public var rows: Int {
        return self.grid.count
    }
    
    public var model: Array<[Int]> {
        return grid.map({ (arr) -> Array<Int> in
            return arr.map({ (item) -> Int in
                if let item = item as? UIView {
                    return item.tag
                }
                else {
                    return 1
                }
            })
        })
    }
    
    // @columns 矩阵列数
    // @items   矩阵元素数组
    public init(columns: Int = 0, items: Array<T> = Array<T>()) {
        self.items = items
        self.columns = columns
        self.layout()
    }
    
    private mutating func layout() {
        var items = self.items
        
        // 检查是否足够分组
        if items.count > columns {
            // 分割数组
            repeat {
                self.grid.append(items.slicing(0, self.columns))
            }
                while items.count > self.columns
        }
        
        // 检查余数
        if items.count > 0 {
            self.grid.append(items)
        }
    }
    
    // 查询元素在矩阵的坐标
    public func index(of element: T ) -> CGPoint? {
        for (x, items) in grid.enumerated() {
            for (y, item) in items.enumerated() {
                if item == element {
                    return CGPoint(x: x, y: y)
                }
            }
        }
        return nil
    }
    
    // 遍历矩阵中的元素
    public func each(_ callback: (Int, Int, T) -> ()) {
        // 第一组循环row, y
        for (y, items) in grid.enumerated() {
            // 第二组循环column, x
            for (x, item) in items.enumerated() {
                callback(x, y, item)
            }
        }
    }
    
    // 查询 row
    // @row Y轴坐标对应的数组为行
    public func get(row: Int) -> Array<T> {
        return row < grid.count ? grid[row] : Array<T>()
    }
    
    // 查询 column
    // @column X轴坐标对应的数组为列
    public func get(column: Int) -> Array<T> {
        var ret = Array<T>()
        self.each { (x, y, item) in
            if column == x {
                ret.append(item)
            }
        }
        return ret
    }
}
