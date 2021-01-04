#
# Be sure to run `pod lib lint PTSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'PTSDK'
  s.version          = '0.1.2'
  s.summary          = 'A tools collection of PainTypeZ.'
  s.swift_versions   = '5.3.0'
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/PainTypeZ/PTSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'PainTypeZ' => 'pengpingjun@icloud.com' }
  s.source           = { :git => 'https://github.com/PainTypeZ/PTSDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'PTSDK/Sources/**/*'
  
  # s.resource_bundles = {
  #   'PTSDK' => ['PTSDK/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'Moya'
  s.dependency 'SwiftyJSON'
#  s.script_phase = { :name => 'SwiftLint', :script => 'if which swiftlint >/dev/null; then
#      swiftlint
#    else
#      echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
#    fi', :execution_position => :before_compile }
  
end
