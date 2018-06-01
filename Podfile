# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

def shared_pods
  pod 'Alamofire', '~> 4.7'
end

target 'Susi' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Susi
  pod 'Material'
  pod 'Toast-Swift', '~> 3.0.0'
  pod 'SwiftValidators'
  pod 'BouncyLayout'
  pod 'RealmSwift'
  pod 'ReadabilityKit'
  pod 'Kingfisher'
  pod 'SwiftDate', '~> 4.5.0'
  pod 'NVActivityIndicatorView'
  pod 'Fakery', '~> 3.3.0'
  pod 'M13Checkbox', :git => 'https://github.com/Marxon13/M13Checkbox.git', :tag => '3.2.2'
  pod 'NotificationBannerSwift'
  pod 'ReachabilitySwift'
  pod 'Localize-Swift'
  pod 'paper-onboarding'
  pod 'PieCharts'
  shared_pods
end

target 'SusiUITests' do
  use_frameworks!
  
  shared_pods
end
