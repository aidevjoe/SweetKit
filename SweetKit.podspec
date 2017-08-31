Pod::Spec.new do |spec|
spec.name             = 'SweetKit'
spec.version          = '0.0.2'
spec.license          = { :type => 'MIT' }
spec.homepage         = 'https://github.com/Joe0708/SweetKit'
spec.authors          = { 'Joe' => 'joesir7@foxmail.com' }
spec.summary          = "一个美妙的Swift扩展集合."
spec.source           = { :git => "https://github.com/Joe0708/SweetKit.git", :tag => spec.version }
spec.platform         = :ios, "8.0"
spec.source_files     = 'SweetKit/SweetKit/**/*.{swift}'
spec.requires_arc     = true
end
