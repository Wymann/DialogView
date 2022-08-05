Pod::Spec.new do |spec|

  spec.name                  = "DialogView"
  spec.version               = "1.0.1"
  spec.summary               = "Objective-C 版本的弹窗效果封装，多功能且简单易用。"
  spec.description           = <<-DESC
    "Objective-C 语言的弹窗库，支持普通弹窗、图片弹窗、输入框弹窗等，也支持设置优先级（弹窗根据优先级先后顺序依次弹出），还支持设置定时消失。等等"
                             DESC

  spec.homepage              = "https://github.com/Wymann/DialogView"
  spec.license               = "MIT"
  spec.author                = { "Wymann chen" => "wymannchan@163.com" }
  spec.platform              = :ios
  spec.ios.deployment_target = "9.0"
  spec.source                = { :git => "https://github.com/Wymann/DialogView.git", :tag => spec.version }
  spec.source_files          = 'DialogView/**/*.{h,m}', 'DialogView/**/**/*.{h,m}'
  spec.resource_bundles      = {
     'DialogView' => ['DialogView/Resources/*']
   }
  
  spec.dependency "SDWebImage"

end
