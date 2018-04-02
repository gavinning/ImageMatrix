//
//  ImageMatrixDelegate.swift
//  deft
//
//  Created by gavinning on 2018/4/2.
//  Copyright © 2018年 gavinning. All rights reserved.
//

import UIKit


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

