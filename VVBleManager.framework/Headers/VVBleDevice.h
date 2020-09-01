//
//  VVBleDevice.h


#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "VVBleAdvDataManagerTool.h"

NS_ASSUME_NONNULL_BEGIN

// command type
typedef NS_ENUM(NSUInteger, VVCommandType){
    //default command
    VVCommandType_SynchronizeTime = 0,
    VVCommandType_readUnit,
    VVCommandType_readSn,
    VVCommandType_POCT,
    
    //normal device
    VVCommandType_ReadHistoryData,
    VVCommandType_DeleteAllHistoryData,
    VVCommandType_DeleteSingleHistoryData,
    VVCommandType_ReadDeviceInfoTargetVersion,
    
    //target value device
    VVCommandType_ReadTargetValue,
    VVCommandType_SetupTargetValue,
    
    //GKI device
    VVCommandType_ReadGKIHistoryData,
    VVCommandType_ReadNumberOfHistoryData,
};
NSString * vvBleDeviceCurrentCommandTypeStringFromType(VVCommandType type);


typedef NS_ENUM(NSInteger, VVBleDeviceUnitType) {
    VVBleDeviceUnitType_unknow = 0, // 设备默认单位
    VVBleDeviceUnitType_mool_L  = 1, // mool/L
    VVBleDeviceUnitType_mg_dL   = 2,  // mg/dL
};

NSString * vvBleDeviceUnitStringFromType(VVBleDeviceUnitType type);
// device unit string
FOUNDATION_EXPORT NSString *const VVBleDeviceUnitString_unknow;
FOUNDATION_EXPORT NSString *const VVBleDeviceUnitString_mool_L;
FOUNDATION_EXPORT NSString *const VVBleDeviceUnitString_mg_dL;

typedef void (^VVResponseDataBlock) (VVCommandType commandType, NSData * originalData, NSDictionary * polishData);

@interface VVBleDevice : NSObject

@property (nonatomic , copy, readonly)  NSString  * name;
@property (nonatomic , copy)  NSString  * macAdress;
@property (nonatomic , copy)  NSString  * sn;
@property (nonatomic , assign, readonly) VVBleDeviceUnitType unitType;
@property (nonatomic , strong, readonly) CBPeripheral * peripheral;

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral
                    centralManager:(CBCentralManager *)centralManager
                               adv:(NSDictionary *)advData;

#pragma mark all device
/*
 * all device command
 * write default data
 
 0.VVCommandType_SynchronizeTime
 1.VVCommandType_readUnit
 2.VVCommandType_readSn
 3.VVCommandType_POCT
 
 */
- (void)writeDefaultDataSucceed:(void (^) (void))succeed
                          error:(void (^) (NSError *error))error;


- (void)sendFixedDataCommand:(VVCommandType)commandType
                 receiveData:(VVResponseDataBlock)receiveDataBlock
            writeDataSucceed:(void (^) (void))writeDataSucceed
                       error:(void (^) (NSError *error))errorBlock;

/*
 GKI设备
 读取多条历史数据
 */
- (void)commandReadHistoryDataNumber:(NSUInteger)number
                         receiveData:(VVResponseDataBlock)receiveDataBlcok
                    writeDataSucceed:(void (^) (void))writeDataSucceed
                                error:(void (^) (NSError *error))errorBlock;

// 有阈值的设备
// 设置血糖值的阈值范围（最大/最小值）
- (void)commandSetupTargetValueMin:(float)min
                               max:(float)max
                  receiveDataBlock:(VVResponseDataBlock)receiveDataBlcok
                  writeDataSucceed:(void (^) (void))writeDataSucceed
                             error:(void (^) (NSError *error))errorBlock;


@end

//bgm data keys
/*
 * device receive data keys
 */
FOUNDATION_EXPORT NSString *const VVKey_POCTDataStateCode;
FOUNDATION_EXPORT NSString *const VVKey_SampleCode;
FOUNDATION_EXPORT NSString *const VVKey_GlucoValue;
FOUNDATION_EXPORT NSString *const VVKey_GlucoTimeKey;
FOUNDATION_EXPORT NSString *const VVKey_deviceUnitType;
FOUNDATION_EXPORT NSString *const VVKey_deviceUnitString;
FOUNDATION_EXPORT NSString *const VVKey_deviceSN;
FOUNDATION_EXPORT NSString *const VVKey_setupDeviceTimeSucceed;
FOUNDATION_EXPORT NSString *const VVKey_HistoryData;//
FOUNDATION_EXPORT NSString *const VVKey_deleteAllHistoryDataSucceed;

FOUNDATION_EXPORT NSString *const VVKey_deleteSingleHistoryDataSucceed;
FOUNDATION_EXPORT NSString *const VVKey_TargetMinValue;
FOUNDATION_EXPORT NSString *const VVKey_TargetMaxValue;
FOUNDATION_EXPORT NSString *const VVKey_setupTargetValueSucceed;
FOUNDATION_EXPORT NSString *const VVKey_ketoneValue;
FOUNDATION_EXPORT NSString *const VVKey_ketoneUnitString;
FOUNDATION_EXPORT NSString *const VVKey_GKIValue;
FOUNDATION_EXPORT NSString *const VVKey_deviceInfoTargetVersion;


FOUNDATION_EXPORT NSString *const kFlagCode_SingleWholeDataSuffix;

//
typedef NS_ENUM(NSUInteger, VVPOCTStateCode) {
    VVPOCTStateCode_pleaseInputPaper      = 10,//请插入试纸
    VVPOCTStateCode_inputPaper            = 11,//已插入试纸条
    VVPOCTStateCode_pleaseInputBlood      = 22,//请加血
    VVPOCTStateCode_waitingResult         = 33,//等待中
    VVPOCTStateCode_result                = 44,//出结果
    VVPOCTStateCode_testError             = 55,//出错
    VVPOCTStateCode_ketonInputPaper       = 66,//血酮检测 已插入试纸条
    VVPOCTStateCode_ketonPleasInputBlood  = 77,//血酮检测 请加血
    VVPOCTStateCode_ketonWaitingResult    = 88,//血酮检测 等待中
    VVPOCTStateCode_ketonResult           = 99,//血酮检测 出结果
};

//
@interface VVBleDevice (WriteData)
@property (nonatomic , assign) VVCommandType commandType;

- (void)vv_sendFixedDataCommand:(VVCommandType)commandType
                          error:(void (^) (NSError *error))errorBlock
                   writeSucceed:(void (^) (void))succeed;

//
- (void)vv_setupTargetMin:(float)min
                 maxValue:(float)max
                    error:(void (^) (NSError *error))errorBlock
             writeSucceed:(void (^) (void))succeed;


- (void)vv_readHistoryDataNumber:(NSUInteger)number
                           error:(void (^) (NSError *error))errorBlock
                    writeSucceed:(void (^) (void))succeed;

@end

FOUNDATION_EXPORT NSString *const kFlagCode_ReadHistoryDataEnd;

//notify
FOUNDATION_EXPORT NSString *const VVNotification_didReadPOCTData;
FOUNDATION_EXPORT NSString *const VVNotification_didReadHistoryData;
FOUNDATION_EXPORT NSString *const VVNotification_deviceDidEnterGKIMode;
FOUNDATION_EXPORT NSString *const VVNotification_deviceDidExitGKIMode;

FOUNDATION_EXPORT NSString *const VVNotification_peripheralDidSetupDefaultDataSucceed;

FOUNDATION_EXPORT NSString *const kPerServiceUUID;
FOUNDATION_EXPORT NSString *const kCharateristicUUID_0;
FOUNDATION_EXPORT NSString *const kCharateristicUUID_1;


typedef NS_ENUM(NSUInteger, VVBleErrorCode) {
    VVBleErrorCode_bleStateUnavailable = 4000,
    VVBleErrorCode_peripheralUnavailiable = 4001,
    
    VVBleErrorCode_writeCharacteristicIsNotFound = 6001,
    VVBleErrorCode_writeValueUnavailiable = 6002,
    
};
@interface VVBleDevice (ParseData)

- (NSDictionary <NSString *,id>*)vv_parseOrigrinalData:(NSString *)origrinalData
                                           commandType:(VVCommandType)commandType;


@end
NS_ASSUME_NONNULL_END


#ifdef DEBUG

#define VVBleLog(...) NSLog(@"%@\n",[NSString stringWithFormat:__VA_ARGS__])
#else

#define VVBleLog(...)
#endif
