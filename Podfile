# Uncomment the next line to define a global platform for your project
# platform :ios, '11.0'

def rx_swift
    pod 'RxSwift', '~> 4.0'
end

def rx_cocoa
    pod 'RxCocoa', '~> 4.0'
end

def test_pods
    pod 'RxBlocking', '~> 4.0'
    pod 'RxTest',     '~> 4.0'
end

target 'UpcomingMovies' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    
    # Pods for UpcomingMovies
    rx_cocoa
    rx_swift
    pod 'Kingfisher', '~> 4.9.0'
    
    target 'UpcomingMoviesTests' do
        inherit! :search_paths
        # Pods for testing
        test_pods
    end
    
    target 'UpcomingMoviesUITests' do
        inherit! :search_paths
        # Pods for testing
    end
    
end

target 'Domain' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Domain
  rx_swift

  target 'DomainTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'NetworkPlatform' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for NetworkPlatform
  rx_swift
  pod 'Moya/RxSwift', '~> 11.0'

  target 'NetworkPlatformTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
