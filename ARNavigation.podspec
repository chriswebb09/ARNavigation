Pod::Spec.new do |s|
  s.name             = 'ARNavigation'
  s.version          = '0.1.1'
  s.summary          = 'Navigation in Augmented reality.'
 
  s.description      = <<-DESC
The tools to setup navigation in augmented reality for iOS 11 ARKit.
                       DESC
 
  s.homepage         = 'https://github.com/chriswebb09/ARNavigation'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Christopher Webb' => 'chris.webb5249@gmail.com' }
  s.source           = { :git => 'https://github.com/chriswebb09/ARNavigation.git', :tag => '0.1.1' }
 
  s.ios.deployment_target = '11.0'
  s.source_files = 'ARNavigation/*.swift'
 
end