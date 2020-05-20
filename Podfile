platform :ios, '11.0'
project 'Arm.xcodeproj'
use_frameworks!
inhibit_all_warnings!

def global_pods
  pod 'ReactiveCocoa', '8.0.2'
  pod 'RealmSwift', '3.13.1'
  pod 'Fabric', '1.9.0'
  pod 'Crashlytics', '3.12.0'
  pod 'MobileVLCKit', '3.3.0'
  pod 'AEXML', '4.1.0'
  pod 'Blockly', '1.2.2'
  pod 'VersionIcon', '~> 1.0.1'
end


target 'Arm' do
  global_pods
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.0'
    end
  end
end
