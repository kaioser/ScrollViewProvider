#
# Be sure to run `pod lib lint ScrollViewProvider.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ScrollViewProvider'
  s.version          = '0.1.0'
  s.summary          = '滑动视图'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://gitee.com/uiop/scroll-view-provider'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yxkkk' => '13730228573@163.com' }
  s.source           = { :git => 'https://gitee.com/uiop/scroll-view-provider.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  s.default_subspec = 'Core'

  s.subspec 'Core' do |core|
      core.source_files = 'ScrollViewProvider/Classes/Core/**/*'
      core.frameworks = 'UIKit'
      core.dependency 'SnapKit'
  end
  
  s.subspec 'Refreshable' do |refreshable|
      refreshable.source_files = 'ScrollViewProvider/Classes/Refreshable/**/*'
      refreshable.dependency 'MJRefresh'
      refreshable.dependency 'ScrollViewProvider/Core'
  end
  
  s.subspec 'Searchable' do |searchable|
      searchable.source_files = 'ScrollViewProvider/Classes/Searchable/**/*'
      searchable.dependency 'ScrollViewProvider/Core'
  end
  
  s.subspec 'Draggable' do |draggable|
      draggable.source_files = 'ScrollViewProvider/Classes/Draggable/**/*'
      draggable.dependency 'ScrollViewProvider/Core'
      draggable.dependency 'Extension'
  end
  
end
