//
//  ImageMatrix.swift
//  ImageMatrix
//
//  Created by gavinning on 2018/3/31.
//  Copyright © 2018年 gavinning. All rights reserved.
//

import UIKit

public class ImageMatrix: UIView {
    // 宽高约束
    public enum Constraint {
        case both
        case width
        case height
        case freedom
    }
    
    // 矩阵间距
    public var spacing: CGFloat = 0 {
        didSet {
            self.layout()
        }
    }
    // 矩阵队列
    public var column: Int = 3 {
        didSet {
            self.layout()
        }
    }
    
    // 矩阵节点
    public var items = Array<ImageMaxtrixItem>() {
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
    
    // 矩阵模型
    public var matrix: Matrix<ImageMaxtrixItem>!
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layout()
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
    }
    
    // 新增元素
    private func add(item: ImageMaxtrixItem) {
        item.alpha = 0
        self.addSubview(item)
    }

    // 删除元素
    private func remove(item: ImageMaxtrixItem) {
        UIView.animate(withDuration: 0.3, animations: { item.alpha = 0 }) { (completed) in
             item.removeFromSuperview()
        }
    }
    
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
            case .freedom: self.rockByFreedom()
        }
    }
    
    private func AutoLayout() -> CGSize {
        let width = (self.frame.width - CGFloat(column-1) * spacing)/CGFloat(column)
        return CGSize(width: width, height: width)
    }
    
    private func rockByBoth() {
        matrix.each { (x, y, item) in
            let offsetX: CGFloat = (spacing + constraintSize.width) * CGFloat(y)
            let offsetY: CGFloat = (spacing + constraintSize.height) * CGFloat(x)

            item.frame.size = self.constraintSize
            
            UIView.animate(withDuration: 0.5, animations: {
                item.alpha = 1
                item.frame.origin = CGPoint(x: offsetX, y: offsetY)
            })
        }
    }
    
    private func rockByWidth() {
        matrix.each { (x, y, item) in
            let offsetX: CGFloat = (spacing + constraintSize.width) * CGFloat(x)
            var offsetY: CGFloat = 0

            // 查询X轴坐标为x的列数组
            matrix.get(column: x)
            // 截断y坐标之前的item
            .slice(0, y)
            // 计算偏移
            .forEach({ (item) in
                offsetY += (item.frame.height + spacing)
            })
            
            item.frame.size.width = constraintSize.width
            
            UIView.animate(withDuration: 0.5, animations: {
                item.alpha = 1
                item.frame.origin = CGPoint(x: offsetX, y: offsetY)
            })
        }
    }
    
    private func rockByHeight() {
        matrix.each { (x, y, item) in
            var offsetX: CGFloat = 0
            let offsetY: CGFloat = (spacing + constraintSize.height) * CGFloat(y)
            
            // 查询Y轴坐标为y的行
            matrix.get(row: y)
                // 截断x坐标之前的item
                .slice(0, x)
                // 计算偏移
                .forEach({ (item) in
                    offsetX += (item.frame.width + spacing)
                })
            
            item.frame.size.height = constraintSize.height
            
            UIView.animate(withDuration: 0.5, animations: {
                item.alpha = 1
                item.frame.origin = CGPoint(x: offsetX, y: offsetY)
            })
        }
    }
    
    private func rockByFreedom() {
        matrix.each { (row, column, item) in
            var offsetX: CGFloat = 0
            var offsetY: CGFloat = 0
            
            // 获取row数组
            matrix.get(row: row)
                // 截断之前的item
                .slice(0, row)
                // 计算偏移
                .forEach({ (item) in
                    offsetX += (item.frame.width + spacing)
                })
            
            // 获取column数组
            matrix.get(column: column)
                // 截断之前的item
                .slice(0, column)
                // 计算偏移
                .forEach({ (item) in
                    offsetY += (item.frame.height + spacing)
                })
            
            item.frame.origin = CGPoint(x: offsetX, y: offsetY)
        }
    }
}

public class ImageMaxtrixItem: UIView {
//    var tmpCenter = CGPoint(x: 0, y: 0)
//    var tmpSize = CGSize(width: 0, height: 0)
    
    public override var frame: CGRect {
        didSet {
            self.layout()
        }
    }
    
    private lazy var deleteIcon: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btn.setImage(UIImage(named: "icon-close-white"), for: .normal)
        btn.contentEdgeInsets = UIEdgeInsets(top: 6, left: 14, bottom: 14, right: 6)
        
        btn.addTarget(self, action: #selector(self.deleteItem), for: .touchUpInside)
        return btn
    }()
    
    // 显示删除按钮
    var showDeleteIcon: Bool = false {
        didSet {
            showDeleteIcon ?
                self.addSubview(deleteIcon):
                deleteIcon.removeFromSuperview()
        }
    }
    
    private func layout() {
        // 更新deleteIcon的位置
        deleteIcon.frame.origin.x = frame.width - deleteIcon.frame.width
    }
    
//    public required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    public convenience init() {
//        self.init(frame: CGRect())
//    }
    
    @objc func deleteItem() {
        if let parent = self.superview as? ImageMatrix {
            parent.items.remove(of: self)
//            print(parent.matrix.model)
        }
    }
    
//    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.tmpCenter = self.center
//        self.tmpSize = self.frame.size
//        UIView.animate(withDuration: 0.15, animations: { () -> Void in
//            self.frame.size = CGSize(width: self.frame.size.width*0.95, height: self.frame.size.height*0.95)
//            self.center = self.tmpCenter
//        })
//    }
//
//    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        UIView.animate(withDuration: 0.15, animations: { () -> Void in
//            self.backgroundColor = .gray
//            self.frame.size = self.tmpSize
//            self.center = self.tmpCenter
//        })
//    }
}
