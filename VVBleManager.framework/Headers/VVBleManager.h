//
//  VVBleManager.h



#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "VVBleAdvDataManagerTool.h"
#import "VVBleDevice.h"


NS_ASSUME_NONNULL_BEGIN

typedef void (^ManagerDidUpdateStateBlock) (CBCentralManager * central);

@interface VVBleManager : NSObject

@property (nonatomic , strong , readonly) CBCentralManager * centralManager;
@property (nonatomic , strong , readonly) VVBleDevice * currentDevice;

@property (nonatomic , copy)  ManagerDidUpdateStateBlock managerDidUpdateStateBlock;

+ (instancetype)shareManager;

/*
 扫描所有 vivachek 的蓝牙设备，这个方法一般用于搜索蓝牙设备列表界面。
 */
- (void)scanAllAvailableVivachekDeviceStop:(NSTimeInterval)stop complete:(void (^) (VVBleDevice * _Nullable device,  NSError * _Nullable  error))scanCompleteHandle;


// 连接指定设备，这里的 参数device必须是上边的方法complete回调block中的device，即扫描到的设备。
- (void)connectToDevice:(VVBleDevice *)device
                succeed:(nonnull void (^) (VVBleDevice * device))succeedBlock
                  error:(void (^) (NSError *error))errorBlock
     disconnectToDevice:(void (^) (VVBleDevice * device, NSError * error))disconnectBlock;

// 扫描并连接指定设备
- (void)scanAndConnectToTargetDeviceMacAdress:(NSString *)macAdress
                               sn:(NSString *)sn
                             stop:(NSTimeInterval)stop
                          succeed:(nonnull void (^) (VVBleDevice * device))succeedBlock
                            error:(void (^) (NSError *error))errorBlock
               disconnectToDevice:(void (^) (VVBleDevice * device, NSError * error))disconnectBlock;

- (void)stopScan;

//此方法内部已包含 取消扫描，取消自动重连
- (void)disconnectCurrentDevice;

//设置需要自动重连的设备，参数device必须要有正确的macAdress和sn
- (void)autoReconnectDevice:(VVBleDevice *)device;

//取消需要自动重连的设备
- (void)autoReconnectCancel;


@end



NSString * _Nonnull VVBleStateDescriptionStringFromState(CBManagerState state);
FOUNDATION_EXPORT NSString *const VVNotification_bleSateUpdate;
FOUNDATION_EXPORT NSString *const VVNotification_peripheralDidDisconnect;
FOUNDATION_EXPORT NSString *const VVNotification_peripheralDidConnect;

NS_ASSUME_NONNULL_END
