Pod::Spec.new do |s|
  s.name             = 'NavigationRouter'
  s.version          = '1.0.1'
  s.summary          = 'A router implementation designed for complex modular apps, written in Swift'
  s.description      = <<-DESC
  NavigationRouter is a router implementation designed for complex modular apps, written in Swift.
                       DESC
  s.homepage         = 'https://github.com/corteggo/NavigationRouter'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'corteggo' => 'cristian.ortega@outlook.es' }
  s.source           = { :git => 'https://github.com/corteggo/NavigationRouter.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/corteggo'
  s.ios.deployment_target = '13.0'
  s.macos.deployment_target = '10.15'
  s.swift_version = '5.0'
  s.source_files = 'Code/**/*'
end
