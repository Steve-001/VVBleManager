Pod::Spec.new do |spec|

  spec.name         = "VVBleManager"
  spec.version      = "1.1.0"
  spec.summary      = "vivachek ble device tools"
  spec.homepage     = "https://github.com/Steve-001/VVBleManager.git"
  
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { "x163one@163.com" => "hank" }
  spec.platform     = :ios
  spec.platform     = :ios, "10.0"
  
  spec.source       = { :git => "https://github.com/Steve-001/VVBleManager.git", :tag => "#{spec.version}" }
 # spec.source_files = "VVBleManager.framework/Headers/*.h"
 # spec.preserve_paths = "VVBleManager.framework/VVBleManager"
  spec.vendored_frameworks = "VVBleManager.framework"
  spec.frameworks = "CoreBluetooth","Foundation"
  spec.requires_arc = true

end
