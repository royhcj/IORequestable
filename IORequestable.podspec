#
# Be sure to run `pod lib lint IORequestable.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'IORequestable'
  s.version          = '0.1.2'
  s.summary          = 'A simple way to define and execute your web API with IORequestable in Swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  IORequestable provides a clean and easy way to create web APIs by encapsulating codable input and output types together with URL request specifications based on an abstraction layer of Moya.
                       DESC

  s.homepage         = 'https://github.com/royhcj/IORequestable'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'royhcj' => 'boyroyh@gmail.com' }
  s.source           = { :git => 'https://github.com/royhcj/IORequestable.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.swift_version = '4.0'

  s.source_files = 'IORequestable/Classes/**/*'
  
  s.default_subspec = "Core"
  
  s.subspec "Core" do |ss|
    ss.source_files = "Sources/Core/"
    ss.dependency 'Alamofire'
    ss.dependency 'Result'
    ss.dependency 'Moya', '~> 12.0.0'
    ss.dependency 'SwiftyJSON', '~> 4.2.0'
  end
  
  s.subspec "RxSwift" do |ss|
    ss.source_files = "Sources/RxSwift/"
    ss.dependency 'IORequestable/Core'
    ss.dependency 'RxSwift', '~> 4.4.0'
    ss.dependency 'RxCocoa', '~> 4.4.0'
  end
  
  # s.resource_bundles = {
  #   'IORequestable' => ['IORequestable/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  # s.dependency 'Alamofire'
  # s.dependency 'Result'
  # s.dependency 'Moya'
  # s.dependency 'SwiftyJSON'
  # s.dependency 'RxSwift'
  # s.dependency 'RxCocoa'
end
