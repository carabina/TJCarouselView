Pod::Spec.new do |s|


  s.name         = "TJCarouselView"
  s.version      = "1.0"
  s.summary      = "a carousel view written in swift"

  s.homepage     = "http://github.com/extie/TJCarouselView"

  s.license      = "MIT"

  s.author       = { "tianjian" => "tianjian0918@gmail.com" }

  s.platform     = :ios
  s.platform     = :ios, "8.0"

  s.source       = { :git => "http://github.com/extie/TJCarouselView.git", :tag => "#{s.version}" }


  s.source_files  = "TJCarouselView/Lib/TJCarouselView/**/*.{h,m}"

  s.requires_arc = true

  s.dependency "Kingfisher", "~> 4.0.0"

end
