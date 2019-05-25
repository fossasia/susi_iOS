# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

def shared_pods
  pod 'Alamofire', '~> 4.7'
end

target 'Susi' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Susi
  pod 'Motion', :git => 'https://github.com/CosmicMind/Motion.git', :branch => 'development'
  pod 'Material', :git => 'https://github.com/CosmicMind/Material.git', :branch => 'development'
  pod 'Toast-Swift', '~> 5.0.0'
  pod 'SwiftValidators', '~> 9.0.1'
  pod 'BouncyLayout'
  pod 'RealmSwift'
  pod 'ReadabilityKit'
  pod 'Kingfisher', '~> 5.0'
  pod 'SwiftDate', '~> 4.5.0'
  pod 'NVActivityIndicatorView', '~> 4.7.0'
  pod 'Fakery', '~> 3.3.0'
  pod 'M13Checkbox', :git => 'https://github.com/Marxon13/M13Checkbox.git', :branch => 'swift_5'
  pod 'ReachabilitySwift'
  pod 'Localize-Swift'
  pod 'paper-onboarding', '~> 6.1.3'
  pod 'FTPopOverMenu_Swift', '~> 0.2.0'
  pod 'CTShowcase', '~> 2.4'
  pod 'SwiftKeychainWrapper'
  shared_pods
end

target 'SusiUITests' do
  use_frameworks!
  
  shared_pods
end
