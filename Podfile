# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'Jiasuqi' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Jiasuqi

	pod 'Masonry'
	pod 'AFNetworking'
	pod 'MJExtension'
	pod 'YYWebImage'
	pod 'Toast'
	pod 'XYIAPKit'
	pod 'XYIAPKit/iTunesReceiptVerify'
	pod 'XYIAPKit/UserDefaultPersistence'
	pod 'XYIAPKit/KeychainPersistence'
end

target 'TunTarget' do
  # Comment the next line if you don't want to use dynamic frameworks
	use_frameworks!
	pod 'CocoaAsyncSocket'
	
end

post_install do |installer|
	installer.generated_projects.each do |project|
		project.targets.each do |target|
			target.build_configurations.each do |config|
				config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
			end
		end
	end
end
