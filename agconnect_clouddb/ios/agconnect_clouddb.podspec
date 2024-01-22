Pod::Spec.new do |s|
  s.name             = 'agconnect_clouddb'
  s.version          = '1.9.0+300'
  s.summary          = 'Flutter plugin for AppGallery Connect Cloud DB SDK.'
  s.description      = <<-DESC
  Cloud DB is a device-cloud synergy database product that provides data synergy management capabilities between the device and cloud, unified data models, and various data management APIs.
  DESC
  s.homepage         = 'https://developer.huawei.com/consumer/en/agconnect/'
  s.license          =  { :type => 'Apache 2.0', :file => '../LICENSE' }
  s.author           = { 'Huawei AGConnect' => 'agconnect@huawei.com' }
  s.source           = { :git => '' }
  s.source_files = 'Classes/**/*'
  s.private_header_files = 'Classes/AGCCloudDB-Bridging-Header.h'
  s.dependency 'Flutter'
  s.dependency 'AGConnectDatabase', '1.9.0.300'
  s.platform = :ios, '9.0'
  s.static_framework = true

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
