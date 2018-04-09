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
                matrix.append(arr.remove(range: 0..<column)!)
            }
            while arr.count > column
        }
        
        // 检查数组余数
        if arr.count > 0 {
            matrix.append(arr)
        }
        return matrix
    }
    
    // 截取区间 改变自身
    public mutating func slice(of range: Range<Int>) {
        self = self.sliced(of: range)!
    }
    
    // 截取区间 改变自身
    public mutating func slice(start: Int, length: Int) {
        self.slice(of: start..<self.index(start, offsetBy: length))
    }
    
    // 截取区间 不改变自身
    public func sliced(of range: Range<Int>) -> [Element]? {
        return Array(self[range])
    }

    // 截取区间 不改变自身
    public func sliced(start: Int, length: Int) -> [Element]? {
        return self.sliced(of: start..<self.index(start, offsetBy: length))
    }
    
    // 某些场景需要数组删除改变自身，并且返回删除的区间
    // 例如上面的matrix方法就是这样的应用场景
    public mutating func remove(range: Range<Int>) -> [Element]? {
        let ret = self.sliced(of: range)
        self.removeSubrange(range)
        return ret
    }
    
    // 不需要 removed(range)
    // self.sliced(of range) 完全可以的达到这个目的
    
    // 查找指定的元素索引
    public mutating func index<T: Equatable>(of element: T) -> Int? {
        for (index, item) in self.enumerated() {
            if let item = item as? T, item == element {
                return index
            }
        }
        return nil
    }
    
    // 删除指定的元素
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
