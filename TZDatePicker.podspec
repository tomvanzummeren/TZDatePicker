Pod::Spec.new do |s|
  s.name             = "TZDatePicker"
  s.version          = "1.0.0"
  s.summary          = "UIDatePicker with optional year"
  s.description      = <<-DESC
  This is a replacement for UIDatePicker, which doesn't support optional years. This date picker does. Optional years are used for birthdays for your contacts for example.
                       DESC
  s.homepage         = "https://github.com/tomvanzummeren/TZDatePicker"
  s.license          = 'MIT'
  s.author           = { "Tom van Zummeren" => "tom.van.zummeren@gmail.com" }
  s.source           = { :git => "https://github.com/tomvanzummeren/TZDatePicker.git", :tag => s.version.to_s }

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Pod/**/*'

end
