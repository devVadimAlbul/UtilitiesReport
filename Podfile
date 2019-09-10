
platform :ios, '10.0'

use_frameworks!
target 'UtilitiesReport' do
    
    pod 'RealmSwift', '~> 3.14'
    pod 'IQKeyboardManagerSwift', '~> 6.2'
    pod 'KRProgressHUD', '~> 3.4'
    pod 'Sourcery', '~> 0.16'
    pod 'SwiftLint', '~> 0.32'
    pod 'Alamofire', '~> 4.8'
    pod 'Stencil', :git => 'https://github.com/stencilproject/Stencil.git'
    pod 'Firebase/Core'
    pod 'Firebase/Auth'
    pod 'Firebase/Firestore'
    pod 'Firebase/Database'
    pod 'Firebase/MLVision'
    pod 'Firebase/MLVisionTextModel'
    pod 'Hero'
    pod 'NVActivityIndicatorView'

    target 'UtilitiesReportTests' do
      inherit! :complete
      pod 'Firebase'
    end
    
end

post_install do |installer_representation|
  installer_representation.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = '$(inherited)'
    end
  end
end
