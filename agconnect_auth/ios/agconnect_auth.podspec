#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint agconnect_auth.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'agconnect_auth'
  s.version          = '1.9.0+300'
  s.summary          = 'Flutter plugin for AppGallery Connect Auth SDK.'
  s.description      = <<-DESC
Flutter plugin for AppGallery Connect Auth SDK.
                       DESC
  s.homepage         = 'https://developer.huawei.com/consumer/en/agconnect/'
  s.license          =  { :type => 'Apache 2.0', :file => '../LICENSE' }
  s.author           = { 'Huawei AGConnect' => 'agconnect@huawei.com' }
  s.source           = { :git => '' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'
  s.static_framework = true

  s.dependency 'AGConnectAuth', '1.9.0.300'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
