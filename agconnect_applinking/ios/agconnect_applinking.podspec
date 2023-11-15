#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint applinking.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'agconnect_applinking'
  s.version          = '1.9.0+300'
  s.summary          = 'HUAWEI AGC App Linking Kit plugin for Flutter.'
  s.description      = <<-DESC
      App Linking allows you to create cross-platform links that can work as 
     defined regardless of whether your app has been installed by a user. 
                       DESC
  s.homepage         = 'https://developer.huawei.com/consumer/en/agconnect/'
  s.license          =  { :type => 'Apache 2.0', :file => '../LICENSE' }
  s.author           = { 'Huawei Technologies' => 'huaweideveloper1@gmail.com' }
  s.source           = { :git => '' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'AGConnectAppLinking' , '1.9.0.300'
  s.platform = :ios, '9.0'
  s.static_framework = true

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
