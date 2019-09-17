Pod::Spec.new do |s|
  s.name         = "FooViewAlpha"
  s.version      = "0.0.1"
  s.summary      = "悬浮按钮工具"
  s.description  = "悬浮按钮工具，类微信"
  s.homepage     = "https://github.com/chenzhe555/FooViewAlpha"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "陈哲" => "376811578@qq.com" }
  s.source       = { :git => "https://github.com/chenzhe555/FooViewAlpha.git", :tag => "#{s.version}" }
  s.source_files = 'FooViewAlpha/FooViewAlphaManager*.{h,m}'
  s.subspec 'classes' do |one|
      one.source_files = 'FooViewAlpha/classes/*.{h,m}'
  end
  s.resource_bundles = {
    'FooViewAlpha' => ['FooViewAlpha/Assets/*']
  }
  s.platform = :ios, "9.0"
  s.frameworks = "Foundation", "UIKit"
  # s.libraries = "iconv", "xml2"
  s.requires_arc = true
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
end