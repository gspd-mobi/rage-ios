Pod::Spec.new do |s|
  s.name             = "Rage"
  s.version          = "0.5.0"
  s.summary          = "Network abstraction layer for iOS applications"

  s.description      = <<-DESC
                       Network abstraction layer for iOS applications.
                       DESC

  s.homepage         = "https://github.com/gspd-mobi/rage-ios"
  s.license          = 'MIT'
  s.author           = { "Pavel Korolev" => "pavel.korolev@gspd.mobi" }
  s.source           = { :git => "https://github.com/gspd-mobi/rage-ios.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.default_subspec = "Core"

  s.subspec "Core" do |ss|
    ss.source_files = 'Rage/*.swift'
    ss.framework = "Foundation"
    ss.dependency 'Result', '~> 2.1'
  end

  s.subspec "RxSwift" do |ss|
    ss.source_files = 'Rage/Dependencies/RxSwift/*.swift'
    ss.dependency "Rage/Core"
    ss.dependency 'RxSwift', '~> 2.0'
  end

  s.subspec "ObjectMapper" do |ss|
    ss.source_files = 'Rage/Dependencies/ObjectMapper/*.swift'
    ss.dependency "Rage/Core"
    ss.dependency 'ObjectMapper', '~> 1.3'
  end

  s.subspec "RxSwiftAndObjectMapper" do |ss|
    ss.source_files = 'Rage/Dependencies/RxSwiftAndObjectMapper/*.swift'
    ss.dependency "Rage/Core"
    ss.dependency "Rage/RxSwift"
    ss.dependency "Rage/ObjectMapper"
  end

end