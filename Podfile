# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

def shared_pods
	pod 'Alamofire'
end

target 'Susi' do
	# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
	use_frameworks!
	
	# Pods for Susi
	pod 'Material'
	pod 'Toast-Swift'
	pod 'SwiftValidators'
	pod 'BouncyLayout'
	pod 'RealmSwift'
	pod 'ReadabilityKit'
	pod 'Kingfisher'
	pod 'SwiftDate', '~> 4.3.0'
	pod 'NVActivityIndicatorView'
	pod 'M13Checkbox', :git => 'https://github.com/Marxon13/M13Checkbox.git'
	pod 'Localize-Swift'
	shared_pods
end

target 'SusiUITests' do
	use_frameworks!
	
	shared_pods
end
