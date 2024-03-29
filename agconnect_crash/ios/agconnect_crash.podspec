#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint agconnect_crash.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'agconnect_crash'
  s.version          = '1.9.0+300'
  s.summary          = 'A Flutter plugin for AGConnect Crash SDK.'
  s.description      = <<-DESC
A Flutter plugin for AGConnect Crash SDK.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'
  s.static_framework = true
  
  s.dependency 'AGConnectCrash', '1.9.0.300'
  s.dependency 'HiAnalytics'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
