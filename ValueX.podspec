Pod::Spec.new do |s|

  # pod lib lint
  # pod trunk push ValueX.podspec

  s.name = "ValueX"
  s.version = "1.0"
  s.summary = "实用的安全对象类型转换库"
  s.homepage = "https://xaoxuu.com/wiki/valuex"
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { "xaoxuu" => "xaoxuu@gmail.com" }
  s.platform = :ios, "8.0"
  s.ios.deployment_target = '8.0'

  s.source = { :git => "https://github.com/xaoxuu/ValueX.git", :tag => "#{s.version}", :submodules => true}

  s.public_header_files = 'ValueX/**/*.{h}'
  s.source_files = 'ValueX/**/*.{h,m}'

  # s.resources = "ValueX/*.{bundle}"

  s.frameworks = "Foundation"
  s.requires_arc = true


end
