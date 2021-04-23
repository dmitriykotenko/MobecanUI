Pod::Spec.new do |spec|
  spec.name             = 'MobecanUI'
  spec.version          = '0.6.4'
  spec.summary          = 'Mobecan UI (and non-UI) helpers'
  spec.homepage         = 'git@github.com:dmitriykotenko/mobecan-ui.git'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author           = { 'Dmitry Kotenko' => 'd.kotenko@gmail.com' }
  spec.source           = { :git => 'git@github.com:dmitriykotenko/mobecan-ui.git',
                         :tag => spec.version.to_s }
  spec.source_files     = 'Sources/**/*.swift'
  spec.frameworks       = 'UIKit', 'Foundation'
  spec.requires_arc     = true
  spec.swift_version    = "5.0"

  spec.dependency 'RxSwift', '~> 5.0'
  spec.dependency 'RxOptional', '~> 4.1.0'
  spec.dependency 'RxGesture', '~> 3.0.2'
  spec.dependency 'RxKeyboard', '~> 1.0.0'

  spec.dependency 'Kingfisher', '~>5.14.0'
  spec.dependency 'SnapKit', '~>5.0.1'

  spec.dependency 'SwiftDateTime', '~> 0.1.4'

  spec.ios.deployment_target = '11.0'
end
