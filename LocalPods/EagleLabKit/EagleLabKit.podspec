Pod::Spec.new do |spec|

  spec.name                  = "EagleLabKit"
  spec.version               = "1.0.0"
  spec.summary               = "鸿鹄 iOS 基础功能组件"
  spec.description           = <<-DESC
    "鸿鹄 iOS 基础功能组件"
                             DESC

  spec.homepage              = "http://10.124.106.120:18080/product/tclplus/Modularise_iOS/eaglelabkit"
  spec.license               = "MIT"
  spec.author                = { "huaizhang.chen" => "huaizhang.chen@tcl.com" }
  spec.platform              = :ios
  spec.ios.deployment_target = "12.4"
  spec.source                = { :git => "http://10.124.106.120:18080/product/tclplus/Modularise_iOS/eaglelabkit.git", :tag => spec.version }
  spec.source_files          = 'EagleLabKit/**/**/*.{swift}'
  # spec.resource_bundles      = {
  #    'EagleLabKit' => ['EagleLabKit/UIComponent/BubbleView/Resources/*', 'EagleLabKit/UIComponent/Popover/Resources/*']
  #  }

end
