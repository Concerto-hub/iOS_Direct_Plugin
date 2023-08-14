#
# Be sure to run `pod lib lint iOS_Direct_Plugin.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'iOS_Direct_Plugin'
  s.version          = '3.0.0'
  s.summary          = 'iOS_Hosted_plugin performs complete transactions.'
  s.swift_version    = '4.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  'Payment Gateway is a robust and cutting-edge technology platform that enables secure online payments.'
                       DESC

  s.homepage         = 'https://github.com/Concerto-hub/iOS_Direct_Plugin'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Concerto-hub' => 'user.mac@concertosoft.com' }
  s.source           = { :git => 'https://github.com/Concerto-hub/iOS_Direct_Plugin.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'Sources/**/*.{swift,h,m}'
    
  s.resources = 'Sources/**/*.storyboard'
  
  # s.resource_bundles = {
  #   'iOS_Direct_Plugin' => ['iOS_Direct_Plugin/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
