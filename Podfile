source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

pre_install do |installer|
    remove_swiftui()
end

platform :ios, '11.0'
target 'XJSwiftKit' do
  
  # Networking
  pod 'Alamofire'
  
  # RxSwift
  pod 'RxSwift','5.0.1'
  pod 'RxCocoa','5.0.0'
  
  # Image
  pod 'Kingfisher'
  
  # Auto Layout
  pod 'SnapKit'
  
  # JSON Mapping
  pod 'HandyJSON','5.0.2'
  
  # Refresh
  pod 'MJRefresh'
  
  # HUD
  pod 'MBProgressHUD'
  pod 'NVActivityIndicatorView'
  
  # Listen Network
  pod 'ReachabilitySwift','4.3.0'
  
  # Keyboard Manager
  pod 'IQKeyboardManagerSwift'
  
  # Video player
  pod 'ZFPlayer', '4.0.1'
  pod 'ZFPlayer/ControlView', '4.0.1'
  pod 'ZFPlayer/AVPlayer', '4.0.1'
  
  # Scan QRCode
  pod 'SGQRCode', '3.5.0'
  
  # Empty View
  pod 'DZNEmptyDataSet','1.8.1'
  
  # Sqlite
  pod 'FMDB','2.7.5'
  
  # Cache Link/File/Sqlite
  pod 'YYCache'
  
  # Select Photo
  pod 'ZLPhotoBrowser'
  
  # PopGesture
  pod 'FDFullscreenPopGesture'
  
  # Carousel
  pod 'FSPagerView'
  
  # Drawer/ CWLateralSlide
  pod 'MMDrawerController'
  
  # Calendar
  pod 'FSCalendar'
  
  # Picker-OC
  pod 'BRPickerView'

  # keyChain
  pod 'SAMKeychain'
  
  # Log
  pod 'CocoaLumberjack/Swift'

end

def remove_swiftui
  # 解决 xcode13 Release模式下SwiftUI报错问题
  system("rm -rf ./Pods/Kingfisher/Sources/SwiftUI")
  code_file = "./Pods/Kingfisher/Sources/General/KFOptionsSetter.swift"
  code_text = File.read(code_file)
  code_text.gsub!(/#if canImport\(SwiftUI\) \&\& canImport\(Combine\)(.|\n)+#endif/,'')
  system("rm -rf " + code_file)
  aFile = File.new(code_file, 'w+')
  aFile.syswrite(code_text)
  aFile.close()
end
