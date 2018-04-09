//
//  ImageMatrixItem.swift
//  ImageMatrix
//
//  Created by gavinning on 2018/4/9.
//  Copyright © 2018年 gavinning. All rights reserved.
//

import UIKit

public class ImageMatrixItem: UIView {
    //    var tmpCenter = CGPoint(x: 0, y: 0)
    //    var tmpSize = CGSize(width: 0, height: 0)
    
    var delegate: ImageMatrixItemDelegate?
    
    public override var frame: CGRect {
        didSet {
            delegate?.imageMatrixItem?(didLayout: self)
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
    public var showDeleteIcon: Bool = false {
        didSet {
            showDeleteIcon ?
                self.addSubview(deleteIcon):
                deleteIcon.removeFromSuperview()
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        // 溢出隐藏
        self.clipsToBounds = true
        self.layout()
    }
    
    public convenience init() {
        self.init(frame: CGRect())
    }
    
    public override func addSubview(_ view: UIView) {
        super.addSubview(view)
        // 删除按钮层级提升
        if showDeleteIcon {
            self.bringSubview(toFront: deleteIcon)
        }
    }
    
    private func layout() {
        // 更新deleteIcon的位置
        deleteIcon.frame.origin.x = frame.width - deleteIcon.frame.width
        // 删除按钮层级提升
        if showDeleteIcon {
            self.bringSubview(toFront: deleteIcon)
        }
    }
    
    // 从父级Matrix视图删除自身
    @objc private func deleteItem() {
        if let parent = self.superview as? ImageMatrix {
            let _ = parent.items.remove(of: self)
            delegate?.imageMatrixItem?(didRemoved: self)
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

