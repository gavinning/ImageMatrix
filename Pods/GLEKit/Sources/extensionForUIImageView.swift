import UIKit

/// 同比例初始化图片
public extension UIImageView {
    
    // @name  图片资源名称 用于构建 UIImage
    // @width 图片显示宽度 高度会根据图片真实宽高比进行换算以保证图片不被拉伸
    public convenience init?(name: String, x: CGFloat = 0, y: CGFloat = 0, width: CGFloat) {
        let image = UIImage(named: name)
        // 图片构建失败时返回nil
        guard image != nil else {
            return nil
        }
        // 同比例计算图片高度
        let height = image!.size.height / image!.size.width * width
        // 构建imageView
        self.init(image: image)
        // 设置图片位置及宽高
        self.frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    public convenience init?(name: String, x: CGFloat = 0, y: CGFloat = 0, height: CGFloat) {
        let image = UIImage(named: name)
        
        guard image != nil else {
            return nil
        }
        
        let width = image!.size.width / image!.size.height * height
        
        self.init(image: image)
        self.frame = CGRect(x: x, y: y, width: width, height: height)
    }
}