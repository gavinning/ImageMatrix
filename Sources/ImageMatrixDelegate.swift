//
//  ImageMatrixDelegate.swift
//  deft
//
//  Created by gavinning on 2018/4/2.
//  Copyright © 2018年 gavinning. All rights reserved.
//

import UIKit


@objc public protocol ImageMatrixDelegate {
    
    // 布局发生改变后
    @objc optional func imageMatrix(didLayout imageMatrix: ImageMatrix, oldFrame: CGRect)
    
    // 新增子元素
    @objc optional func imageMatrix(imageMatrix: ImageMatrix, didAdded item: ImageMatrixItem)
    
    // 子元素被删除
    @objc optional func imageMatrix(imageMatrix: ImageMatrix, didRemoved item: ImageMatrixItem)
    
    // 子视图发生改变 新增和删除都会处理该代理
    // 当子视图新增和删除后处理同一种逻辑时，推荐实现该代理
    @objc optional func imageMatrix(imageMatrix: ImageMatrix, didChanged item: ImageMatrixItem, event: ImageMatrix.Event)
}
