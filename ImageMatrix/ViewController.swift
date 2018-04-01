//
//  ViewController.swift
//  ImageMatrix
//
//  Created by gavinning on 2018/3/31.
//  Copyright © 2018年 gavinning. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var index: Int = 0
    var matrix: ImageMatrix!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let btn = UIButton(frame: CGRect(x: 30, y: 450, width: 100, height: 30))
        btn.setTitle("add item", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        
        btn.addTarget(self, action: #selector(addItem), for: .touchUpInside)
        
        self.view.addSubview(btn)
        
        
        self.imageMatrix()
    }
    
    @objc func addItem() {
        self.matrix.items.append(self.createItem())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageMatrix() {
        self.matrix = ImageMatrix(frame: CGRect(x: 0, y: 50, width: view.frame.width, height: view.frame.width))
        self.matrix.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        
        // 设置间隔
        self.matrix.spacing = 20
        // 设置列
        self.matrix.column = 3
        // 插入item
        self.matrix.items += self.createItems()

        view.addSubview(self.matrix)
    }
    
    func createItem() -> ImageMaxtrixItem {
        let label = UILabel()
        let item = ImageMaxtrixItem()
        
        self.index += 1
        let title = String(self.index)
        
        label.text = title
        label.textColor = .green
        label.sizeToFit()
        item.addSubview(label)
        item.backgroundColor = .lightGray
        item.tag = self.index
        
        item.showDeleteIcon = true
        
        return item
    }
    
    func createItems() -> Array<ImageMaxtrixItem> {
        var arr = Array<ImageMaxtrixItem>()
        
        for _ in 0..<4 {
            arr.append(self.createItem())
        }
        return arr
    }
}

