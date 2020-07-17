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
 mac:scaned peripheral mac.
 sn: scaned peripheral sn
 stop: scan time. if stop = 0,not stop
 if mac nil and sn nil,scaned all vivachek device.
 */
- (void)scanVivachekDeviceMac:(nullable NSString *)mac
                           sn:(nullable NSString *)sn
                         stop:(NSTimeInterval)stop
                     complete:(void (^) (VVBleDevice * _Nullable device,  NSError * _Nullable  error))scanCompleteHandle;


- (void)connectToDevice:(VVBleDevice *)device
                succeed:(nonnull void (^) (VVBleDevice * device))succeedBlock
                  error:(void (^) (NSError *error))errorBlock
     disconnectToDevice:(void (^) (VVBleDevice * device, NSError * error))disconnectBlock;

- (void)scanAndConnectToDeviceMac:(NSString *)mac
                               sn:(NSString *)sn
                             stop:(NSTimeInterval)stop
                          succeed:(nonnull void (^) (VVBleDevice * device))succeedBlock
                            error:(void (^) (NSError *error))errorBlock
               disconnectToDevice:(void (^) (VVBleDevice * device, NSError * error))disconnectBlock;

- (void)stopScan;
- (void)disconnectCurrentDevice;
- (void)autoReconnectDevice:(VVBleDevice *)device;
- (void)autoReconnectCancel;


@end


NSString * _Nonnull VVBleStateDescriptionStringFromState(CBManagerState state);
FOUNDATION_EXPORT NSString *const VVNotification_bleSateUpdate;
FOUNDATION_EXPORT NSString *const VVNotification_peripheralDidDisconnect;
FOUNDATION_EXPORT NSString *const VVNotification_peripheralDidConnect;

NS_ASSUME_NONNULL_END
