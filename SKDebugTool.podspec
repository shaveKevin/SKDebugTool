Pod::Spec.new do |s|
  s.name         = "SKDebugTool"
  s.version      = "0.0.8"
  s.summary      = "ios developer  debugTool"
  s.description  = <<-DESC
                   debugTool
                   SKDebugTool
                   DESC
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage     = "https://github.com/shaveKevin/SKDebugTool"
  s.authors      = { 'shavekevin' => 'shavekevin@gmail.com' }
  s.social_media_url   = "http://www.shavekevin.com"
  s.platform     = :ios,"7.0"
  s.requires_arc = true
  s.source_files = 'SKDebugTool/**/*.{h,m}'
  s.public_header_files = 'SKDebugTool/**/*.{h}'
  s.source       = { :git => "https://github.com/shaveKevin/SKDebugTool.git", :tag => "0.0.8" }
  s.frameworks = 'Foundation'
end
