#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint appmetrica_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'appmetrica_plugin'
  s.version          = '3.0.0'
  s.summary          = 'AppMetrica SDK for Flutter'
  s.homepage         = 'https://appmetrica.io/'
  s.license          = { :type => 'PROPRIETARY', :file => '../LICENSE' }
  s.authors          = { "Yandex LLC" => "admin@appmetrica.io" }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*', 'AppMetricaPlugin/*.{h,m}'
  s.public_header_files = 'Classes/**/*.h', 'AppMetricaPlugin/*.h'
  s.dependency 'Flutter'
  s.dependency 'AppMetricaAnalytics', '~> 5.3'
  s.static_framework = true
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
