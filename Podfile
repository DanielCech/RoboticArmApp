platform :ios, '11.0'
project 'Arm.xcodeproj'
use_frameworks!
inhibit_all_warnings!

def global_pods
  pod 'ReactiveCocoa'
  pod 'RealmSwift'
  pod 'Fabric'
  pod 'Crashlytics'
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
