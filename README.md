#  VVBleManager

## VVBleManager

## 搜索 链接 设备
### 搜索  设备
```
- (void)viewDidLoad {
    [super viewDidLoad];
    VVBleManager * manager = [VVBleManager shareManager];
    __weak typeof(self) weakSelf = self;
    [manager setManagerDidUpdateStateBlock:^(CBCentralManager * central) {
        [weakSelf updateLabelState:central.state];
        if (central.state == CBManagerStatePoweredOn) {
            [weakSelf scanDevice];
        }
    }];
    self.bleManager = manager;
}

扫描所有有效的vivachek蓝牙设备
- (void)scanDevice{
  //
  [self.bleManager scanAllAvailableVivachekDeviceStop:3 complete:^(VVBleDevice * _Nullable device, NSError * _Nullable error) {
      if(error){
          VVBleLog(@"------scanDeviceError----- error:%@",error);
          
      }
      
      if (device) {
          VVBleLog(@"-------searchedDevice-------  device:%@",device);
          
      }
  }];
}
```


###  连接指定设备。
这里的 参数device必须是上边的方法complete回调block中的device，即扫描到的设备。
此方法已默认封装了 给设备发送默认命令（同步设备时间，读取设备单位，读取设备sn号，同步测量命令）

```
- (void)connectToDevice:(VVBleDevice *)device{
    __weak typeof(self) weakSelf = self;
    [self.bleManager connectToDevice:device succeed:^(VVBleDevice * _Nonnull device) {
        /*
        连接设备，并且发送默认命令数据成功
        默认命令数据包括：
        0.VVCommandType_SynchronizeTime
        1.VVCommandType_readUnit
        2.VVCommandType_readSn
        3.VVCommandType_POCT
        
        */
        VVBleLog(@"-----connectSucceed----- device:%@",device);
        
        
    } error:^(NSError * _Nullable error) {
        //连接设备出错，或者写入默认数据出错
        VVBleLog(@"-----connectFail----- device:%@ error:%@",device,error);
        
    } disconnectToDevice:^(VVBleDevice * _Nonnull device, NSError * _Nonnull error) {
        //设备断开链接
        VVBleLog(@"-----disconnectToDevice----- device:%@ error:%@",device,error);
    }];
}
```

## 设备命令数据交互


```
// 可以给设备发送的命令
typedef NS_ENUM(NSUInteger, VVCommandType){
    //default command   默认命令
    VVCommandType_SynchronizeTime = 0,
    VVCommandType_readUnit,
    VVCommandType_readSn,
    VVCommandType_POCT,
    
    //normal device    普通设备
    VVCommandType_ReadHistoryData,
    VVCommandType_DeleteAllHistoryData,
    VVCommandType_DeleteSingleHistoryData,
    VVCommandType_ReadDeviceInfoTargetVersion,
    
    //下面的这几个命令，普通设备暂时用不到。
    //target value device   有阈值的设备
    VVCommandType_ReadTargetValue,
    VVCommandType_SetupTargetValue,
    
    //GKI device    GKI设备
    VVCommandType_ReadGKIHistoryData,
    VVCommandType_ReadNumberOfHistoryData,
};
```
### 读取 所有历史数据

```
- (void)readAllHistoryData{
  
  //内部已默认发送了 实时测量的命令，不用另外发送 实时测量命令数据，即可接受实时测量数据
  [[VVBleManager shareManager].currentDevice sendFixedDataCommand:VVCommandType_ReadHistoryData receiveData:^(VVCommandType commandType, NSData * _Nonnull originalData, NSDictionary * _Nonnull polishData) {
      
      NSString * string = [NSString stringWithFormat:@"---ReadTargetValue--- device:%@ \ncommandType:%lu \noriginalData:%@ \npolistData:%@",weakSelf.device,(unsigned long)commandType,originalData,polishData];
      VVBleLog(@"%@",string);
      
      
  } writeDataSucceed:^{
      
  } error:^(NSError * _Nonnull error) {
      VVBleLog(@"error:%@",error);
      
      
  }];
}
```

### 通知监听 实时测量 返回的数据

```
- (void)registNotifi{
    
    [[NSNotificationCenter defaultCenter] addObserverForName:VVNotification_didReadPOCTData object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
       
        NSDictionary * polishData = note.object;
        NSString *state = [polishData objectForKey:VVKey_POCTDataStateCode];
        VVPOCTStateCode stateCode = [state integerValue];
        if (stateCode == VVPOCTStateCode_pleaseInputPaper) {
            
            VVBleLog(@"please input paper");
        }else if (stateCode == VVPOCTStateCode_inputPaper ||
                  stateCode == VVPOCTStateCode_ketonInputPaper) {
            
            VVBleLog(@"intputed paper");
        }else if (stateCode == VVPOCTStateCode_pleaseInputBlood ||
                  stateCode == VVPOCTStateCode_ketonPleasInputBlood) {
            
            VVBleLog(@"please input blood");
        }else if (stateCode == VVPOCTStateCode_waitingResult ||
                  stateCode == VVPOCTStateCode_ketonWaitingResult) {
            //
            VVBleLog(@"waiting result");
        }else if (stateCode == VVPOCTStateCode_result ||
                  stateCode == VVPOCTStateCode_ketonResult) {
            // 出结果
            NSString *bgmValue = [polishData objectForKey:VVKey_GlucoValue];
            NSString * deviceUnit = [polishData objectForKey:VVKey_deviceUnitType];
            NSString *warStr = [NSString stringWithFormat:@"%@:%.1f%@",@"测量结果",[bgmValue floatValue],deviceUnit];
            
            VVBleLog(@"%@",warStr);
        }
        
       
    }];
}
```

### 设置需要自动重连的设备
如果设置了需要自动重连的设备，手机蓝牙断开后重新打开后，会自动重连设备。
```
VVBleDevice * device = [[VVBleDevice alloc] init];
device.macAdress = @"69:9B:F3:7A:14:14";
device.sn = @"104C000011A";
[[VVBleManager shareManager] autoReconnectDevice:device];
```

### 取消自动重连
```
[[VVBleManager shareManager] autoReconnectCancel];
```
 

>  更多 数据交互，参考demo
