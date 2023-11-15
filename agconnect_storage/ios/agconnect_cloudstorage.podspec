#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint agconnect_cloudstorage.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'agconnect_cloudstorage'
  s.version          = '1.9.0+301'
  s.summary          = 'Flutter plugin for AppGallery Connect Cloud Storage SDK.'
  s.description      = <<-DESC
Flutter plugin for AppGallery Connect Cloud Storage SDK.
                       DESC
  s.homepage         = 'https://developer.huawei.com/consumer/en/agconnect/'
  s.license          =  { :type => 'Apache 2.0', :file => '../LICENSE' }
  s.author           = { 'Huawei AGConnect' => 'agconnect@huawei.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'AGConnectStorage' ,'~> 1.9.0.300'
  s.platform = :ios, '9.0'
  s.static_framework = true

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
