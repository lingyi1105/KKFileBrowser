#
# Be sure to run `pod lib lint KKFileBrowser.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KKFileBrowser'
  s.version          = '1.0.0'
  s.summary          = '一个非常实用的文件浏览工具，可以预览图片，也可以可视化数据库。'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  一个非常实用的文件浏览工具，下次再来补充吧。
                       DESC

  s.homepage         = 'https://github.com/HansenCCC/KKFileBrowser'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'chenghengsheng' => 'chenghs@shinemo.com' }
  s.source           = { :git => 'https://github.com/HansenCCC/KKFileBrowser.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'KKFileBrowser/Classes/**/*'
  
  # s.resource_bundles = {
  #   'KKFileBrowser' => ['KKFileBrowser/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
