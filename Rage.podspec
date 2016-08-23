Pod::Spec.new do |s|
  s.name             = "Rage"
  s.version          = "0.2.0"
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

  s.source_files = 'Rage/**/*'
  s.frameworks = 'Foundation'

  s.dependency 'RxSwift', '~> 2.0'
  s.dependency 'ObjectMapper', '~> 1.3'

end