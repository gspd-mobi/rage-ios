use_frameworks!

def common_pods
    pod 'RxSwift', '= 3.0.0-rc.1'
    pod 'ObjectMapper', '~> 2.1.0'
    pod 'Result', '~> 3.0.0'
end

target 'RageExample' do
    common_pods
end

target 'Rage' do
    common_pods

end

target 'RageTests' do
    common_pods
    pod 'Quick', '~> 0.10.0'
    pod 'Nimble', '~> 5.1.0'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |configuration|
            configuration.build_settings['SWIFT_VERSION'] = "3.0"
        end
    end
end
