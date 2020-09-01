Pod::Spec.new do |spec|

  spec.name         = "VVBleManager"
  spec.version      = "1.2.0"
  spec.summary      = "vivachek ble device tools"
  spec.homepage     = "https://github.com/Steve-001/VVBleManager.git"
  spec.source       = { :git => "https://github.com/Steve-001/VVBleManager.git", :tag => "#{spec.version}" }
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { "hank" => "x163one@163.com" }
  
  spec.platform     = :ios, "10.0"
  
  spec.vendored_frameworks = "VVBleManager.framework"
  spec.frameworks = "CoreBluetooth","Foundation"
  spec.requires_arc = true

end
