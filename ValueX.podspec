Pod::Spec.new do |s|

  # pod lib lint
  # pod trunk push ValueX.podspec

  s.name = "ValueX"
  s.version = "1.3.1"
  s.summary = "实用的安全对象类型转换库"
  s.homepage = "https://xaoxuu.com/wiki/valuex"
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { "xaoxuu" => "git@xaoxuu.com" }
  s.platform = :ios, "9.0"
  s.ios.deployment_target = '9.0'

  s.source = { :git => "https://github.com/xaoxuu/ValueX.git", :tag => "#{s.version}", :submodules => true}

  s.public_header_files = 'Sources/**/*.{h}'
  s.source_files = 'Sources/**/*.{h,m}'

  # s.resources = "ValueX/*.{bundle}"

  s.frameworks = "Foundation"
  s.requires_arc = true


end
