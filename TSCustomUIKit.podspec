#
#  Be sure to run `pod spec lint TSCustomUIKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

s.name         = "TSCustomUIKit"
s.version      = "0.0.9"
s.summary      = "this is app custom UIKit"

s.description  = <<-DESC
这是一个通用的UI组件，封装了一些常用的UI，segment pageController uiimage等等
DESC
s.platform     = :ios, "9.0"
s.homepage     = "https://www.jianshu.com/u/8a7102c0b777"

s.license      = { :type => "MIT", :file => "LICENSE" }

s.author             = { "yuchenH" => "huangyuchen@caiqr.com" }

s.source       = { :git => "http://gitlab.caiqr.com/ios_module/TSCustomUIKit.git", :tag => s.version }

s.framework  = "UIKit","Foundation"

s.swift_version = '4.0'

s.requires_arc = true

s.subspec 'PageController' do |ss|
ss.source_files = 'TSCustomUIKit/pageController/*'
ss.dependency 'TSUtility'
end

s.subspec 'UIExtension' do |ss|
ss.source_files = 'TSCustomUIKit/UIExtension/*.swift','TSCustomUIKit/UIExtension/TSEmptyView/*.swift'
ss.dependency 'Kingfisher'
ss.dependency 'SnapKit'
ss.dependency 'TSUtility'
ss.dependency 'TSNetworkMonitor'
end

s.subspec 'Segmented' do |ss|
ss.source_files = 'TSCustomUIKit/Segmented/*'
ss.dependency 'TSUtility'
ss.dependency 'SnapKit'
end

s.subspec 'TableView' do |ss|
ss.source_files = 'TSCustomUIKit/TableView/*'
end

s.subspec 'TSRPhotoBrowser' do |ss|
ss.source_files = 'TSCustomUIKit/TSRPhotoBrowser/*'
ss.dependency 'Kingfisher'
end

s.subspec 'TSTabbarController' do |ss|
ss.source_files = 'TSCustomUIKit/TSTabbarController/TSTabbarControl/*','TSCustomUIKit/TSTabbarController/TSTabbarUtility/*'
end

s.subspec 'KeyBoardBar' do |ss|
ss.source_files = 'TSCustomUIKit/KeyBoardBar/*'
ss.dependency 'SnapKit'
end

s.subspec 'TSTextfield' do |ss|
ss.source_files = 'TSCustomUIKit/TSTextfield/*'
ss.dependency 'SnapKit'
ss.dependency 'TSUtility'
end

s.subspec 'TSToast' do |ss|
ss.source_files = 'TSCustomUIKit/TSToast/*'
ss.dependency 'SnapKit'
ss.dependency 'TSUtility'
end

end
