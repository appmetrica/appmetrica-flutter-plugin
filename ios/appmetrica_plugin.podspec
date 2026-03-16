#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint appmetrica_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'appmetrica_plugin'
  s.version          = '3.5.0'
  s.summary          = 'AppMetrica SDK for Flutter'
  s.homepage         = 'https://appmetrica.io/'
  s.license          = { :type => 'PROPRIETARY', :file => '../LICENSE' }
  s.authors          = { "Yandex LLC" => "admin@appmetrica.io" }
  s.source           = { :path => '.' }
  s.source_files = 'appmetrica_plugin/Sources/appmetrica_plugin/**/*.{h,m}'
  s.public_header_files = 'appmetrica_plugin/Sources/appmetrica_plugin/include/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'AppMetricaAdSupport', '~> 6.1'
  s.dependency 'AppMetricaCore', '~> 6.1'
  s.dependency 'AppMetricaCoreExtension', '~> 6.1'
  s.dependency 'AppMetricaCrashes', '~> 6.1'
  s.dependency 'AppMetricaIDSync', '~> 6.1'
  s.dependency 'AppMetricaLibraryAdapter', '~> 6.1'
  s.dependency 'AppMetricaScreenshot', '~> 6.1'
  s.dependency 'AppMetricaWebKit', '~> 6.1'
  s.static_framework = true
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
