//
//  VVBleAdvDataManagerTool.h
//
//  Created by zhx on 2018/3/13.
//  Copyright © 2018年 zhx. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface VVBleAdvDataManagerTool : NSObject

/*
 *搜索过滤设备
 * sn  需要搜索的设备sn号
 * macAdress  需要搜索的设备mac地址
 *  如果 sn macAdress 都传nil。搜索所有有效设备
 */
+ (BOOL)isAvailableDeviceOnDiscoverPeripheralName:(NSString *)name
                                advertisementData:(NSDictionary *)advertisementData
                                             RSSI:(NSNumber *)RSSI
                                        scanForSn:(nullable NSString *)sn
                                       scanForMac:(nullable NSString *)macAdress;

//通过广播包数据，获取设备的 mac地址
+ (NSString *)macAdressString:(NSDictionary *)advData;

//通过广播包数据，获取设备的 sn号
+ (NSString *)snString:(NSDictionary *)advData;



+ (BOOL)saveDeviceInfoToUserDefaultWithSn:(NSString *)sn macAdress:(NSString *)macAdress;
+ (NSDictionary *)getLocalDeviceInfoFromUserDefault;

@end


FOUNDATION_EXPORT NSString * _Nonnull const kAdvServiceUUID_0;
FOUNDATION_EXPORT NSString * _Nonnull const kAdvServiceUUID_1;


NS_ASSUME_NONNULL_END



typedef NSString * VVDateFormatStringOption NS_STRING_ENUM;

FOUNDATION_EXPORT VVDateFormatStringOption const _Nonnull VVDateFormatStringOption_yyyy_MM_dd;
FOUNDATION_EXPORT VVDateFormatStringOption const _Nonnull VVDateFormatStringOption_yyyy_MM_dd_HH;
FOUNDATION_EXPORT VVDateFormatStringOption const _Nonnull VVDateFormatStringOption_yyyy_MM_dd_HH_mm;
FOUNDATION_EXPORT VVDateFormatStringOption const _Nonnull VVDateFormatStringOption_yyyy_MM_dd_HH_mm_ss;
FOUNDATION_EXPORT VVDateFormatStringOption const _Nonnull VVDateFormatStringOption_MM_dd;
FOUNDATION_EXPORT VVDateFormatStringOption const _Nonnull VVDateFormatStringOption_HH_mm_ss;
FOUNDATION_EXPORT VVDateFormatStringOption const _Nonnull VVDateFormatStringOption_HH_mm;


NS_ASSUME_NONNULL_BEGIN

@interface NSString (VVExtension)


- (int)vv_int16StringToInt10Value;
- (BOOL)vv_containedByStrings:(NSArray <NSString *>*)strs;

+ (NSString *)vv_stringFromDate:(NSDate *)date format:(VVDateFormatStringOption)dateFormat;

/*
 验证 是否是mac地址。
 首先看一个MAC地址：48:5D:60:61:3D:C5。
 其中由6个字节（十六进制）组成，简单理解为数字、大小写字母（a-fA-F）、冒号 : 组成
*/
- (BOOL)vv_isAvailableMacadress;

@end

NS_ASSUME_NONNULL_END



NS_ASSUME_NONNULL_BEGIN

@interface NSData (VVExtension)


//data转换为 string
- (NSString *)vv_dataToOriginalString;


//originalString to data
+ (NSData *)vv_dataFromOriginalString:(NSString *)originalString;


@end

NS_ASSUME_NONNULL_END
