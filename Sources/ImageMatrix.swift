//
//  ImageMatrix.swift
//  ImageMatrix
//
//  Created by gavinning on 2018/3/31.
//  Copyright © 2018年 gavinning. All rights reserved.
//

import UIKit

public class ImageMatrix: UIView {
    var delegate: ImageMatrixDelegate?
    
    // 是否开启动画
    public var isAnimate: Bool = true
    // 新入场Item不施加位移动画
    private var immunityMap: Dictionary<ImageMatrixItem, Bool> = [:]

    // 动画时间
    // item删除动画时间
    private let deleteTime = 0.3
    // 矩阵resize动画时间
    private let resizeTime = 0.3
    // item位移动画时间
    private let displaceTime = 0.4
    
    
    // 宽高约束
    public enum Constraint {
        case both
        case width
        case height
    }
    
    // item减少时重新计算矩阵所占空间
    public enum Resize {
        case both
        case width
        case height
    }
    
    public override var frame: CGRect {
        didSet {
            delegate?.imageMatrix?(didLayout: self, oldFrame: oldValue)
        }
    }
    
    // 矩阵间距
    public var spacing: CGFloat = 0 {
        didSet {
            self.layout()
        }
    }
    // 矩阵列数
    public var column: Int = 3 {
        didSet {
            self.layout()
        }
    }
    // 矩阵行数
    public private(set) var row: Int = 0
    
    // 矩阵节点
    // 此数组的更改会反馈到UI上
    // 也就是说只需要操作该数组即可达到对矩阵增删操作
    public var items = Array<ImageMatrixItem>() {
        didSet {
            
            let old = oldValue
            let new = items
            
            let oldSet = Set(old)
            let newSet = Set(new)
            
            let willRemove = oldSet.subtracting(newSet)
            let willAdd = newSet.subtracting(oldSet)
            
            // 对比删除
            if !willRemove.isEmpty {
                old.forEach { (item) in
                    if willRemove.contains(item) {
                        self.remove(item: item)
                    }
                }
            }
            
            // 对比新增
            if !willAdd.isEmpty {
                new.forEach { (item) in
                    if willAdd.contains(item) {
                        self.add(item: item)
                    }
                }
            }
            
            // 更新矩阵模型
            self.matrix = Matrix(columns: self.column, items: items)
            // 重新计算布局
            self.layout()
        }
    }
    
    // 宽高约束
    public var constraint: Constraint = .both
    // 根据宽高约束的条件生效
    // Constraint.both 宽高约束皆生效
    // Constraint.width 宽度约束生效
    // Constraint.height 高度约束生效
    // Constraint.freedom 自由模式没有约束
    // TODO 更多自定义功能后续版本完善
    private var constraintSize: CGSize = CGSize(width: 0, height: 0)
    
    // 是否启用自动布局 启用自动布局自行设置的宽高将会失效
    // 并且强制启用 Constraint.both 约束条件
    // 建议在对齐网格模式启用 即 四宫格、九宫格、十六宫格
    // TODO 允许非自动布局功能后续版本完善
    private private(set) var autoLayout: Bool = true
    
    // 矩阵模型 用于计算图片矩阵的位置
    private var matrix = Matrix<ImageMatrixItem>() {
        didSet {
            self.row = self.matrix.rows
        }
    }
    
    // 已使用空间
    private var usedSpace = CGSize()

    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
    }
    
    public override func sizeToFit() {
        self.sizeToFit(by: .both)
    }
    
    public func sizeToFit(by resize: Resize) {
        var width: [CGFloat] = [0]
        var height: [CGFloat] = [0]
        
        for index in 0..<matrix.rows {
            width.append(
                matrix
                    .get(row: index)
                    .map { (item) -> CGFloat in
                        return item.frame.width
                    }
                    .reduce(0) { (a, b) -> CGFloat in
                        return a + b
                }
            )
        }
        
        for index in 0..<matrix.columns {
            height.append(
                matrix
                    .get(column: index)
                    .map { (item) -> CGFloat in
                        return item.frame.height
                    }
                    .reduce(0) { (a, b) -> CGFloat in
                        return a + b
                }
            )
        }
        
        usedSpace.width = width.max()! + CGFloat([self.column-1, 0].max()!)*spacing
        usedSpace.height = height.max()! + CGFloat([self.row-1, 0].max()!)*spacing
        
        if isAnimate {
            UIView.animate(withDuration: resizeTime) {
                switch resize {
                case .both: self.frame.size = self.usedSpace
                case .width: self.frame.size.width = self.usedSpace.width
                case .height: self.frame.size.height = self.usedSpace.height
                }
            }
        }
        
        else {
            switch resize {
            case .both: self.frame.size = self.usedSpace
            case .width: self.frame.size.width = self.usedSpace.width
            case .height: self.frame.size.height = self.usedSpace.height
            }
        }
    }
    
    // 新增元素
    private func add(item: ImageMatrixItem) {
        item.alpha = 0
        self.addSubview(item)
        self.delegate?.imageMatrix?(imageMatrix: self, didAdded: item)
        UIView.animate(withDuration: isAnimate ? deleteTime : 0) {
            item.alpha = 1
        }
    }
    
    // 删除元素
    private func remove(item: ImageMatrixItem) {
        UIView.animate(withDuration: isAnimate ? deleteTime : 0, animations: { item.alpha = 0 }) { (completed) in
            item.removeFromSuperview()
            self.delegate?.imageMatrix?(imageMatrix: self, didRemoved: item)
        }
    }
    
    // 重新布局
    private func layout() {
        guard items.count > 0 else {
            return
        }
        
        // 如果自动布局为true 则自动计算constraintSize的值
        if autoLayout {
            constraintSize = self.AutoLayout()
        }
        
        switch constraint {
        case .both: self.rockByBoth()
        case .width: self.rockByWidth()
        case .height: self.rockByHeight()
        }
        
        self.sizeToFit(by: .height)
    }
    
    // 启用自动布局时计算约束宽高
    private func AutoLayout() -> CGSize {
        let width = (self.frame.width - CGFloat(column-1) * spacing)/CGFloat(column)
        return CGSize(width: width, height: width)
    }
    
    // constraint.both 情况下的布局计算
    private func rockByBoth() {
        matrix.each { (x, y, item) in
            let offsetX: CGFloat = (spacing + constraintSize.width) * CGFloat(x)
            let offsetY: CGFloat = (spacing + constraintSize.height) * CGFloat(y)
            
            item.frame.size = self.constraintSize
            
            // 新增Item不施加位移动画
            if immunityMap[item] == nil {
                immunityMap[item] = true
                item.frame.origin = CGPoint(x: offsetX, y: offsetY)
            }
            else {
                UIView.animate(withDuration: isAnimate ? displaceTime : 0, animations: {
                    item.frame.origin = CGPoint(x: offsetX, y: offsetY)
                })
            }
        }
    }
    
    // constraint.width 情况下的布局计算
    private func rockByWidth() {
        matrix.each { (x, y, item) in
            let offsetX: CGFloat = (spacing + constraintSize.width) * CGFloat(x)
            var offsetY: CGFloat = 0
            
            // 查询X轴坐标为x的列数组
            matrix.get(column: x)
                // 截断y坐标之前的item
                .sliced(of: 0..<y)?
                // 计算偏移
                .forEach({ (item) in
                    offsetY += (item.frame.height + spacing)
                })
            
            item.frame.size.width = constraintSize.width
            item.frame.origin = CGPoint(x: offsetX, y: offsetY)
        }
    }
    
    // constraint.height 情况下的布局计算
    private func rockByHeight() {
        matrix.each { (x, y, item) in
            var offsetX: CGFloat = 0
            let offsetY: CGFloat = (spacing + constraintSize.height) * CGFloat(y)
            
            // 查询Y轴坐标为y的行
            matrix.get(row: y)
                // 截断x坐标之前的item
                .sliced(of: 0..<x)?
                // 计算偏移
                .forEach({ (item) in
                    offsetX += (item.frame.width + spacing)
                })
            
            item.frame.size.height = constraintSize.height
            item.frame.origin = CGPoint(x: offsetX, y: offsetY)
        }
    }
}

