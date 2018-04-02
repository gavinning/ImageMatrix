ImageMatrix
---
图片矩阵，当然也可以做其他UI矩阵  
  
  
![](imageMatrix.gif)


### Usage
```swift
let imageMatrix = ImageMatrix(frame: CGRect(x: 0, y: 50, width: 375, height: 375))

// 设置间隔
self.matrix.spacing = 20
// 设置列 2为4宫格 3为9宫格
self.matrix.column = 3

// items属性对应矩阵内的UIView
// 对items执行增删操作，即会反应到UI上
// 在UI上的增删实际也是对该数组的增删
self.matrix.items = [ImageMaxtrixItem(), ImageMaxtrixItem()]

self.view.addSubview(imageMatrix)
```

```swift
// ImageMaxtrixItem是UIView的子类
// 矩阵的元素是由ImageMaxtrixItem进行创建
var item = ImageMaxtrixItem()

// 是否显示删除按钮
item.showDeleteIcon = true

// item.frame被改变之后将会触发此回调
item.didLayout = {
	// do sth
}
```