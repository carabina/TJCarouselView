Pod::Spec.new do |s|


  s.name         = "TJCarouselView"
  s.version      = "1.0"
  s.summary      = "a carousel view written in swift"

  s.homepage     = "https://github.com/extie/TJCarouselView"

  s.license      = "MIT"

  s.author       = { "extie" => "tianjian0918@gmail.com" }

  s.platform     = :ios
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/extie/TJCarouselView.git", :tag => "#{s.version}" }


  s.source_files  = "TJCarouselView/Lib/TJCarouselView/**/*.swift"

  s.requires_arc = true

  s.dependency "Kingfisher", "~> 4.0.0"

end
