Pod::Spec.new do |spec|
  spec.name         = 'TextureForm'
  spec.version      = '0.1'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com'
  spec.source       = { :git => 'https://github.com/strangeliu/TextureForm' }
  spec.authors      = { 'strangeliu' => 'strangeliu@gmail.com' }
  spec.summary      = 'Form for ASDK'

  spec.ios.deployment_target = '9.0'

  spec.public_header_files  = 'Source/*.h'
  spec.source_files = 'Source/*.{h,m,swift}'
  spec.dependency 'Texture/Core', '~> 2.6'
  spec.dependency 'DifferenceKit'

end
