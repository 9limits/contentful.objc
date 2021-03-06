Pod::Spec.new do |s|
  s.name             = "ContentfulDeliveryAPIAppExtension"
  s.version          = "1.9.3"
  s.summary          = "Objective-C SDK for Contentful s Content Delivery API."
  s.homepage         = "https://github.com/contentful/contentful.objc/"
  s.license = 'MIT'
  s.author          = { "Boris Bügling" => "boris@buegling.com" }
  s.source          = { :git => "https://github.com/9limits/contentful.objc.git", :tag => 'master' }
  s.social_media_url = 'https://twitter.com/contentful'

  s.platform     = :ios, '6.0'
  s.ios.deployment_target     = '6.0'

  s.requires_arc = true

  s.source_files         = 'Code/*.{h,m}',
  s.public_header_files  = 'Code/{CDAArray,CDAAsset,CDAClient,CDAConfiguration,CDAContentType,CDAEntry,CDAError,CDAField,CDANullabilityStubs,CDARequest,CDAResource,CDAResponse,CDASpace,CDASyncedSpace,ContentfulDeliveryAPI,CDAPersistenceManager,CDAPersistedAsset,CDAPersistedEntry,CDAPersistedSpace,CDALocalizablePersistedEntry,CDALocalizedPersistedEntry}.h'


  s.ios.source_files          = 'Code/*.{h,m}', 'Code/UIKit/*.{h,m}'
  s.ios.frameworks            = 'UIKit', 'MapKit'
  s.ios.public_header_files  = 'Code/UIKit/{CDAEntriesViewController,CDAFieldsViewController,UIImageView+CDAAsset,CDAMapViewController,CDAResourcesCollectionViewController,CDAResourcesViewController,CDAResourceCell}.h'

  s.osx.deployment_target     = '10.8'

  s.dependency 'AFNetworking', '~> 2.5.3'
  s.dependency 'ISO8601DateFormatter'
end
