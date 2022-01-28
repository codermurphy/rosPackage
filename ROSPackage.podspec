#
# Be sure to run `pod lib lint ROSPackage.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ROSPackage'
  s.version          = '0.1.0'
  s.summary          = 'ros common package.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/codermurphy/rosPackage'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'murphy' => 'lj472840101@163.com' }
  s.source           = { :git => 'https://github.com/codermurphy/rosPackage.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  
  s.swift_version = '5.5'

  s.source_files = 'ROSPackage/Classes/**/*.{h,mm,m,swift}'
  
  # s.resource_bundles = {
  #   'ROSPackage' => ['ROSPackage/Assets/*.png']
  # }

#   s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
