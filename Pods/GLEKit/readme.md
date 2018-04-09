GLEKit
---
一些基础扩展

### Install
```sh
pod install GLEKit
```

### Requirements
* iOS 9.0+
* Swift 4.0+

### Usage
```swift
// GLE

// 延迟
GLE.delay(1.0) {
    // do sth
}

// 根据某个view查询root ViewController
let rootViewController = GLE.findRootViewController(by: [:UIView])

// 简单的日期格式化
let com = GLE.dateFormat("2016-16-18 18:00:00", dateFormat: "yyyy-MM-dd HH:mm:ss")
com.year
com.month
com.day
com.hour
com.minute
com.second

// 查询某个view的剩余空间
let size = GLE.remainderSize(from: [:UIView])
```

```swift
// For Array

// 创建一个2维矩阵
func matrix( column: Int ) -> [[Element]]

// 截取区间 改变自身
func slice(of range: Range<Int>)
// 截取区间 改变自身
func slice(start: Int, length: Int)

// 截取区间 不改变自身
func sliced(of range: Range<Int>) -> [Element]?
// 截取区间 不改变自身
func sliced(start: Int, length: Int) -> [Element]?

// 某些场景需要数组删除一个区间，改变自身，并且返回删除的区间
// 例如上面的matrix方法就是这样的应用场景
// 不需要返回值的 可以调用内置的 removeSubrange 方法
func remove(range: Range<Int>) -> [Element]?

// 删除指定的元素
func remove<T: Equatable>(of element: T) -> T?

// 查找指定的元素索引
func index<T: Equatable>(of element: T) -> Int?
```

```swift
// For String

// 截取区间 改变自身
func slice(of range: CountableRange<Int>)

// 截取区间 改变自身
func slice(start: Int, length: Int)

// 截取区间 不改变自身
func sliced(of range: CountableRange<Int>) -> String?

// 截取区间 不改变自身
func sliced(start: Int, length: Int) -> String?

// 删除区间 改变自身 且返回删除区间
func remove(range: CountableRange<Int>) -> String?
```

```swift
// For UIColor

// 一个常用的便利方法 UIColor(0,0,0,0.1)
// 内部自动除以255，参数直接传值即可
convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat)
```

```swift
// For UIImageView

// 等比缩放图片 传入宽度等比缩放高度
convenience init?(name: String, x: CGFloat = 0, y: CGFloat = 0, width: CGFloat)

// 等比缩放图片 传入高度等比缩放宽度
convenience init?(name: String, x: CGFloat = 0, y: CGFloat = 0, height: CGFloat)

```