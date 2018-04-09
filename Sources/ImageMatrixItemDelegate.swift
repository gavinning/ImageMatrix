//
//  ImageMatrixItemDelegate.swift
//  ImageMatrix
//
//  Created by gavinning on 2018/4/9.
//  Copyright © 2018年 gavinning. All rights reserved.
//

import UIKit

@objc public protocol ImageMatrixItemDelegate {
    
    // 布局发生改变后
    @objc optional func imageMatrixItem(didLayout item: ImageMatrixItem)
    
    // 被删除时
    @objc optional func imageMatrixItem(didRemoved item: ImageMatrixItem)
}

