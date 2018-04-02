//
//  Array.swift
//  ImageMatrix
//
//  Created by gavinning on 2018/3/31.
//  Copyright © 2018年 gavinning. All rights reserved.
//

import UIKit

public extension Array {
    // 以数组创建矩阵
    public func matrix( column: Int ) -> [[Element]] {
        var arr = self
        var matrix = [[Element]]()
        
        // 检查是否足够分组
        if arr.count > column {
            // 分割数组为矩阵
            repeat {
                matrix.append(arr.slicing(0, column))
            }
            while arr.count > column
        }
        
        // 检查数组余数
        if arr.count > 0 {
            matrix.append(arr)
        }
        return matrix
    }
    
    public func slice(_ start: Int, _ end: Int) -> [Element] {
        return Array(self[start..<end])
    }
    
    public func slice(_ start: Int, distance: Int) -> [Element] {
        return self.slice(start, self.index(start, offsetBy: distance))
    }
    
    public mutating func slicing(_ start: Int, _ end: Int) -> [Element] {
        let result = Array(self[start..<end])
        self.removeSubrange(start..<end)
        return result
    }

    public mutating func slicing(_ start: Int, distance: Int) -> [Element] {
        return self.slicing(start, self.index(start, offsetBy: distance))
    }
    
    public mutating func splice(_ start: Int, _ end: Int) -> [Element] {
        return self.slicing(start, end)
    }
    
    public mutating func splice(_ start: Int, distance: Int) -> [Element] {
        return self.slicing(start, distance)
    }
    
    public mutating func index<T: Equatable>(of element: T) -> Int? {
        for (index, item) in self.enumerated() {
            if let item = item as? T, item == element {
                return index
            }
        }
        return nil
    }
    
    public mutating func remove<T: Equatable>(of element: T) -> T? {
        let index = self.index(of: element)
        if let index = index {
            return self.remove(at: index) as? T
        }
        else {
            return nil
        }
    }
    
    // 简单洗牌
    public func shuffle() ->Array<Element> {
        if self.count <= 1 {
            return self
        }
        
        var ran = 0
        var arr = self
        var random = arr
        var map = Dictionary<Int,Bool>()
        // 清空
        random.removeAll()
        // 随选
        repeat {
            ran = Int(arc4random())%Int(arr.count)
            if map[ran] != true {
                random.append(arr[ran])
                arr.remove(at: ran)
            }
        }
        while arr.count > 0
        
        return random
    }
}
