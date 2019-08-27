Pod::Spec.new do |s|

# pod lib lint
# pod trunk push ValueX.podspec

  s.name = "ValueX"
  s.version = "1.0"
  s.summary = "实用的安全对象类型转换库"
  s.homepage = "http://xaoxuu.com"
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { "xaoxuu" => "xaoxuu@gmail.com" }
  s.platform = :ios, "8.0"
  s.ios.deployment_target = '8.0'
  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/xaoxuu/ValueX.git", :tag => "#{s.version}", :submodules => true}

  # s.source_files  = "ValueX/**/*.{h,m}"
  s.public_header_files = 'ValueX/**/*.{h}'
  s.source_files = 'ValueX/**/*.{h,m}'

  # s.exclude_files = "Classes/Exclude"
  # s.public_header_files = 'ValueX/**/*.{h}'

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"
  s.resources = "ValueX/*.{bundle}"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  s.frameworks = "Foundation", "UIKit", 'QuartzCore', 'CoreGraphics'
  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  s.requires_arc = true


end
