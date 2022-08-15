Pod::Spec.new do |spec|

  spec.name                  = "BubbleView"
  spec.version               = "1.0.1"
  spec.summary               = "Swift 版本的弹窗效果封装，多功能且简单易用。"
  spec.description           = <<-DESC
    "Swift 语言的弹窗库，支持普通弹窗、图片弹窗、输入框弹窗等，也支持设置优先级（弹窗根据优先级先后顺序依次弹出），还支持设置定时消失。等等"
                             DESC

  spec.homepage              = "https://github.com/Wymann/BubbleView"
  spec.license               = "MIT"
  spec.author                = { "Wymann chen" => "wymannchan@163.com" }
  spec.platform              = :ios
  spec.swift_version         = '5.0'
  spec.ios.deployment_target = "10.0"
  spec.source                = { :git => "https://github.com/Wymann/BubbleView", :tag => spec.version }
  spec.source_files          = 'BubbleView/**/*.{swift}', 'BubbleView/**/**/*.{swift}'
  spec.resource_bundles      = {
     'BubbleView' => ['BubbleView/Resources/*']
   }
  
  spec.dependency 'Kingfisher'
  spec.dependency 'SnapKit'

end
