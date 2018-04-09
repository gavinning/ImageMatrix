import UIKit

public extension String {

    // 截取区间 改变自身
    public mutating func slice(of range: CountableRange<Int>) {
        self = self.sliced(of: range)!
    }
    
    // 截取区间 改变自身
    public mutating func slice(start: Int, length: Int) {
        self = self.sliced(start: start, length: length)!
    }
    
    // 截取区间 不改变自身
    public func sliced(of range: CountableRange<Int>) -> String? {
        let start = self.index(self.startIndex, offsetBy: range.lowerBound)
        let end = self.index(self.startIndex, offsetBy: range.upperBound)
        return String(self[start..<end])
    }
    
    // 截取区间 不改变自身
    public func sliced(start: Int, length: Int) -> String? {
        let start = self.index(self.startIndex, offsetBy: start)
        let end = self.index(start, offsetBy: length)
        return String(self[start..<end])
    }
    
    // 删除区间 改变自身 且返回删除区间
    public mutating func remove(range: CountableRange<Int>) -> String? {
        let start = self.index(self.startIndex, offsetBy: range.lowerBound)
        let end = self.index(self.startIndex, offsetBy: range.upperBound)
        let ret = String(self[start..<end])
        self.removeSubrange(start..<end)
        return ret
    }
}
