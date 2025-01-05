#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint kinde_flutter_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'kinde_flutter_sdk_macos'
  s.version          = '0.0.1'
  s.summary          = 'Macos implementation of the kinde_flutter_sdk plugin.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'FlutterMacOS'
  s.dependency 'AppAuth', '>= 1.6.2'
  s.platform = :osx, '10.15'
  s.osx.source_files = 'macos/Classes/KindeFlutterSdkMacosPlugin.swift'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
