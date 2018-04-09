Pod::Spec.new do |s|

  s.name         = "ImageMatrix"
  s.version      = "0.2.1"
  s.summary      = "简单的图片矩阵."
  s.homepage     = "https://github.com/gavinning/ImageMatrix"
  s.license      = "MIT"
  s.author       = { "gavinning" => "ningyubo@gmail.com" }
  s.source       = { :git => "https://github.com/gavinning/ImageMatrix.git", :tag => s.version }
  s.platform     = :ios, "10.0"
  s.framework    = "UIKit"
  s.source_files = "Sources/*.swift"

  s.dependency "GLEKit"

end
