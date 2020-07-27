
#  
 https://github.com/Steve-001/VVBleTestDemo.git

已集成 pod，如果 pod search 不到， pod repo update.  再 search
```
pod 'VVBleManager'
```


-------------------------------
2020-07-17  release 1.0.0

2020-01-27  release 1.1.0


---------------------------------
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
- (void)scanDevice{
  //
  [self.bleManager scanVivachekDeviceMac:nil sn:nil stop:3 complete:^(VVBleDevice * _Nullable device, NSError * _Nullable error) {
      if(error){
          VVBleLog(@"------scanDeviceError----- error:%@",error);
          
      }
      
      if (device) {
          VVBleLog(@"-------searchedDevice-------  device:%@",device);
          
      }
  }];
}
```


### 连接 设备
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
### 读取设备 所有历史数据
```
- (void)readAllHistoryData{
  
  //内部已默认 发送了 实时测量的命令，不用另外发送 实时测量命令数据，即可接受实时测量数据
  [[VVBleManager shareManager].currentDevice sendFixedDataCommand:VVCommandType_ReadHistoryData receiveData:^(VVCommandType commandType, NSData * _Nonnull originalData, NSDictionary * _Nonnull polishData) {
      
      NSString * string = [NSString stringWithFormat:@"---ReadTargetValue--- device:%@ \ncommandType:%lu \noriginalData:%@ \npolistData:%@",weakSelf.device,(unsigned long)commandType,originalData,polishData];
      VVBleLog(@"%@",string);
      
      
  } writeDataSucceed:^{
      
  } error:^(NSError * _Nonnull error) {
      VVBleLog(@"error:%@",error);
      
      
  }];
}
```

### 通知 监听 实时测量数据
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


##### 更多 数据交互，参考demo
