//
//  lib.swift
//  GLEKit
//
//  Created by gavinning on 2018/4/8.
//  Copyright © 2018年 gavinning. All rights reserved.
//

import UIKit

public class GLE {
    
    
    private init() {}
    
    // 延迟
    public static func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    // 查找ViewController
    public static func findRootViewController(by view: UIView) -> UIViewController? {
        var next: UIView? = view
        repeat{
            if let nextResponder = next?.next, nextResponder.isKind(of: UIViewController.self) {
                return (nextResponder as! UIViewController)
            }
            next = next?.superview
        } while next != nil
        return nil
    }
    
    // 格式化日期
    public static func dateFormat(_ time: String, dateFormat format: String = "yyyy-MM-dd HH:mm:ss") -> DateComponents? {
        let date: Date?
        let formater = DateFormatter()
        
        formater.dateFormat = format
        date = formater.date(from: time)
        
        guard date != nil else {
            return nil
        }
        
        return Calendar.current.dateComponents([.year, .month, .day, .minute, .hour, .second], from: date!)
    }
    
    // UIView剩余空间
    public static func remainderSize(from view: UIView) -> CGSize {
        // 子视图占用宽度
        let width = view.subviews.map { (subview) -> CGFloat in
            return subview.frame.width + subview.frame.origin.x
            }.max() ?? 0
        // 子视图占用高度
        let height = view.subviews.map { (subview) -> CGFloat in
            return subview.frame.height + subview.frame.origin.y
            }.max() ?? 0
        // 剩余可自动布局空间
        // 文档流排序时可参考使用
        return CGSize(width: view.frame.width - width, height: view.frame.height - height)
    }
}
