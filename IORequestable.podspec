#
# Be sure to run `pod lib lint IORequestable.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'IORequestable'
  s.version          = '0.1.11'
  s.summary          = 'A simple way to define and execute your web API with IORequestable in Swift.'

  s.description      = <<-DESC
  IORequestable provides a clean and easy way to create web APIs by encapsulating codable input and output types together with URL request specifications based on an abstraction layer of Moya.
                       DESC

  s.homepage         = 'https://github.com/royhcj/IORequestable'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'royhcj' => 'boyroyh@gmail.com' }
  s.source           = { :git => 'https://github.com/royhcj/IORequestable.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.5'

  s.default_subspec = "Core"
  
  s.subspec "Core" do |ss|
    ss.source_files = 'IORequestable/Classes/Core/**/*'
    ss.dependency 'Alamofire', '~> 5.0'
    ss.dependency 'Moya', '~> 15.0.0'
  end
  
  s.subspec "RxSwift" do |ss|
    ss.source_files = 'IORequestable/Classes/RxSwift/**/*'
    ss.dependency 'IORequestable/Core'
    ss.dependency 'RxSwift', '~> 6.0'
    ss.dependency 'RxCocoa', '~> 6.0'
  end

end
