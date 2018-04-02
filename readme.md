ImageMatrix
---
图片矩阵，当然也可以做其他矩阵  
  

![](imageMatrix.gif)

  

### Requirements
* iOS 10.0+
* Swift 4.0+

### Usage
```swift
let imageMatrix = ImageMatrix(frame: CGRect(x: 0, y: 50, width: 375, height: 375))

// 设置间隔
imageMatrix.spacing = 20
// 设置列 2为4宫格 3为9宫格
imageMatrix.column = 3

// items属性对应矩阵内的UIView
// 对items执行增删操作，即会反应到UI上
// 在UI上的增删实际也是对该数组的增删
imageMatrix.items = [ImageMatrixItem(), ImageMatrixItem()]

self.view.addSubview(imageMatrix)
```
  
ImageMatrixItem
```swift
// ImageMatrixItem是UIView的子类
// 矩阵的元素是由ImageMatrixItem进行创建
var item = ImageMatrixItem()

// 是否显示删除按钮
item.showDeleteIcon = true
```

delegate
```swift
@objc protocol ImageMatrixDelegate {
    
    // 布局发生改变后
    @objc optional func imageMatrix(didLayout imageMatrix: ImageMatrix, oldFrame: CGRect)
    
    // 新增子元素
    @objc optional func imageMatrix(imageMatrix: ImageMatrix, didAdded item: ImageMatrixItem)
    
    // 子元素被删除
    @objc optional func imageMatrix(imageMatrix: ImageMatrix, didRemoved item: ImageMatrixItem)
}

@objc public protocol ImageMatrixItemDelegate {
    
    // 布局发生改变后
    @objc optional func imageMatrixItem(didLayout item: ImageMatrixItem)
    
    // 被删除时
    @objc optional func imageMatrixItem(didRemoved item: ImageMatrixItem)
}
```