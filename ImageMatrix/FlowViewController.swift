//
//  FlowViewController.swift
//  ImageMatrix
//
//  Created by gavinning on 2018/3/31.
//  Copyright © 2018年 gavinning. All rights reserved.
//

import UIKit

class FlowViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.imageMatrix()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageMatrix() {
        let imageMatrix = ImageMatrix(frame: CGRect(x: 0, y: 50, width: view.frame.width, height: view.frame.width))
        imageMatrix.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        

        // 设置间隔
        imageMatrix.spacing = 20
        // 设置列
        imageMatrix.column = 3
        // 插入item
        imageMatrix.items += self.createItems()

        
        view.addSubview(imageMatrix)
    }
    
    func createItem() -> ImageMaxtrixItem {
        let label = UILabel()
        let item = ImageMaxtrixItem()
        
        label.text = "Matrix"
        label.textColor = .green
        label.sizeToFit()
        item.addSubview(label)
        item.backgroundColor = .gray
        print(CGFloat(arc4random()%300))
        item.frame.size = CGSize(width: 100, height: CGFloat(arc4random()%200))
        
        return item
    }
    
    func createItems() -> Array<ImageMaxtrixItem> {
        var arr = Array<ImageMaxtrixItem>()
        
        for _ in 0..<8 {
            arr.append(self.createItem())
        }
        return arr
    }
}

