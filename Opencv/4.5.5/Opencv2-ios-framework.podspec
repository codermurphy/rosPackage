#
#  Be sure to run `pod spec lint Opencv2-ios-framework.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name             = 'Opencv2-ios-framework'
  s.version          = '4.5.5'
  s.summary          = 'OpenCV (Computer Vision) for iOS as a dynamic framework.'

  s.description      = <<-DESC
  OpenCV: open source computer vision library
      Homepage: http://opencv.org
      Online docs: http://docs.opencv.org
      Q&A forum: http://answers.opencv.org
      Dev zone: http://code.opencv.org
                       DESC

  s.homepage         = 'https://opencv.org/'
  s.license          = { :type => '3-clause BSD', :text => ' By downloading, copying, installing or using the software you agree to this license.If you do not agree to this license, do not download, install copy or use the software' }
  s.author           = 'opencv.org"'
  s.source           = { :http => 'https://github.com/opencv/opencv/releases/download/4.5.5/opencv-4.5.5-ios-framework.zip', :sha256 => '60d4d44aac22a4ca8de069fc43d218e3dad777e440e69f8bd7ca2be635c3bde1' }
  
  s.ios.deployment_target = "9.0"
  # s.static_framework = true
  s.preserve_paths = "opencv2.framework"
  s.source_files = "opencv2.framework/Versions/A/Headers/**/*{.h,.hpp}"
  s.public_header_files = "opencv2.framework/Versions/A/Headers/**/*{.h,.hpp}"
  s.header_dir = "opencv2"
  s.header_mappings_dir = "opencv2.framework/Versions/A/Headers/"
  s.vendored_frameworks = "opencv2.framework"
  s.libraries = [ 'stdc++' ]
  s.frameworks = [
    "Accelerate",
    "AssetsLibrary",
    "AVFoundation",
    "CoreGraphics",
    "CoreImage",
    "CoreMedia",
    "CoreVideo",
    "Foundation",
    "QuartzCore",
    "UIKit"
    ]
  # s.requires_arc = false

  # s.ios.pod_target_xcconfig = {'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'}
  # s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

end
