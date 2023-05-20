#
# Be sure to run `pod lib lint ScrollViewProvider.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'ScrollViewProvider'
    s.version          = '0.1.1'
    s.summary          = '滑动视图'
    
    s.description      = <<-DESC
    TODO: Add long description of the pod here.
    DESC
    
    s.homepage         = 'https://github.com/kaioser/ScrollViewProvider'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'yangxiongkai' => 'yangxiongkai@126.com' }
    s.source           = { :git => 'https://github.com/kaioser/ScrollViewProvider.git', :tag => s.version.to_s }
    
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
        draggable.dependency 'Extension/Array'
    end
    
end
