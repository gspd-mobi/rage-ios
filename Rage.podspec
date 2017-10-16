Pod::Spec.new do |s|
  s.name             = "Rage"
  s.version          = "0.10.4"
  s.summary          = "Pragmatic network abstraction layer for iOS applications"
  s.homepage         = "https://github.com/gspd-mobi/rage-ios"
  s.license          = "MIT"
  s.author           = { "Pavel Korolev" => "pavel.korolev@gspd.mobi" }
  s.source           = { :git => "https://github.com/gspd-mobi/rage-ios.git", :tag => s.version.to_s }

  s.platform     = :ios, "9.0"
  s.requires_arc = true

  s.default_subspec = "Core"

  s.subspec "Core" do |ss|
    ss.source_files = "Rage/*.swift", "Rage/Plugins/*.swift"
    ss.framework = "Foundation"
    ss.dependency "Result", "~> 3.2.1"
  end

  s.subspec "RxSwift" do |ss|
    ss.source_files = "Rage/Dependencies/RxSwift/*.swift"
    ss.dependency "Rage/Core"
    ss.dependency "RxSwift", "~> 3.3.1"
  end

  s.subspec "ObjectMapper" do |ss|
    ss.source_files = "Rage/Dependencies/ObjectMapper/*.swift"
    ss.dependency "Rage/Core"
    ss.dependency "ObjectMapper", "~> 2.2.5"
  end

  s.subspec "RxSwiftAndObjectMapper" do |ss|
    ss.source_files = "Rage/Dependencies/RxSwiftAndObjectMapper/*.swift"
    ss.dependency "Rage/Core"
    ss.dependency "Rage/RxSwift"
    ss.dependency "Rage/ObjectMapper"
  end

end
