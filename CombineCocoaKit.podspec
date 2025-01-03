#
# Be sure to run `pod lib lint CombineCocoaKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'CombineCocoaKit'
    s.version          = '0.1.0'
    s.summary          = 'CombineCocoaKit.'
    
    s.description      = <<-DESC
    TODO: Add long description of the pod here.
    DESC
    
    s.homepage         = 'https://github.com/BestiOSDev/CombineCocoaKit'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'dongzb01' => 'dzb8818082@163.com' }
    s.source           = { :git => 'https://github.com/BestiOSDev/CombineCocoaKit.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    s.requires_arc     = true
    s.swift_version = ' 5.0'
    s.ios.deployment_target = '13.0'
    s.frameworks = 'Combine', 'Foundation', 'UIKit'
    s.source_files = 'CombineCocoaKit/Classes/**/*.{swift,h,m}'
end
