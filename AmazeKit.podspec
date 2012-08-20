Pod::Spec.new do |s|
  s.name     = 'AmazeKit'
  s.version  = '0.8.0'
  s.authors  = {'Jeff Kelley' => 'SlaunchaMan@gmail.com'}
  s.license  = 'Proprietary'
  s.homepage = 'https://github.com/detroit-labs/AmazeKit'
  s.summary  = 'AmazeKit is a library for rendering beautiful images in your iOS app'
  s.source   = { :git => 'git@github.com:detroit-labs/AmazeKit.git', :tag => '0.8.0' }
  s.platform = :ios
  s.requires_arc = true
  s.source_files = 'AmazeKit/AmazeKit/*.{h,m}'
end
