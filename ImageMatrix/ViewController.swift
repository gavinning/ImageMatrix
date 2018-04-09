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
        
        
        let btn = UIButton(frame: CGRect(x: 30, y: 30, width: 100, height: 30))
        btn.setTitle("新增", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        btn.addTarget(self, action: #selector(addItem), for: .touchUpInside)
        
        let btn2 = UIButton(frame: CGRect(x: 150, y: 30, width: 100, height: 30))
        btn2.setTitle("改变", for: .normal)
        btn2.setTitleColor(.black, for: .normal)
        btn2.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        btn2.addTarget(self, action: #selector(shuffle), for: .touchUpInside)
        
        self.view.addSubview(btn)
        self.view.addSubview(btn2)
        self.imageMatrix()
    }
    
    @objc func addItem() {
        self.matrix.items.append(self.createItem())
    }
    
    @objc func shuffle() {
        self.matrix.items = self.matrix.items.shuffle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageMatrix() {
        self.matrix = ImageMatrix(frame: CGRect(x: 0, y: 80, width: view.frame.width, height: 0))
        self.matrix.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.2)
        self.matrix.delegate = self
        
        // 设置间隔
        self.matrix.spacing = 20
        // 设置列
        self.matrix.column = 3
        // 插入item
        self.matrix.items += self.createItems()

        view.addSubview(self.matrix)
    }
    
    func createItem() -> ImageMatrixItem {
        let item = ImageMatrixItem()
        let imageView = UIImageView()
        
        item.delegate = self
        
        self.index += 1
        
        if self.index > 19 {
            self.index = 1
        }
        
        let title = String(self.index)
        
        imageView.image = UIImage(named: title)
        imageView.sizeToFit()
        
        item.showDeleteIcon = true
        item.addSubview(imageView)

        return item
    }
    
    func createItems() -> Array<ImageMatrixItem> {
        var arr = Array<ImageMatrixItem>()
        
        for _ in 0..<5 {
            arr.append(self.createItem())
        }
        return arr
    }
}

extension UIViewController: ImageMatrixDelegate {
    // 当矩阵内新增item时
    func imageMatrix(imageMatrix: ImageMatrix, didAdded item: ImageMatrixItem) {
        imageMatrix.sizeToFit(by: .height)
        print(imageMatrix.frame.height)
    }
    
    // 当矩阵内的item被删除时
    func imageMatrix(imageMatrix: ImageMatrix, didRemoved item: ImageMatrixItem) {
        imageMatrix.sizeToFit(by: .height)
    }
}

extension UIViewController: ImageMatrixItemDelegate {
    // item 布局发生改变时
    public func imageMatrixItem(didLayout item: ImageMatrixItem) {
        if let imageView = item.subviews[0] as? UIImageView {
            // 同比缩放
            let width = imageView.frame.width
            let height = imageView.frame.height
            
            // 横图
            if width >= height {
                imageView.frame.size.width = item.frame.height/height*width
                imageView.frame.size.height = item.frame.height
                imageView.center = CGPoint(x: item.frame.width/2, y: item.frame.height/2)
            }
                // 竖图
            else {
                imageView.frame.size.width = item.frame.width
                imageView.frame.size.height = item.frame.width/width*height
            }
        }
    }
}
