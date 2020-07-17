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
 * scanForSn  需要搜索的设备sn号
 * scanForMac  需要搜索的设备mac地址
 *  如果 scanForSn scanForMac 都传nil。搜索所有有效设备
 */
+ (BOOL)isAvailableDeviceOnDiscoverPeripheralName:(NSString *)name
                                advertisementData:(NSDictionary *)advertisementData
                                             RSSI:(NSNumber *)RSSI
                                        scanForSn:(nullable NSString *)scanForSn
                                       scanForMac:(nullable NSString *)scanForMac;

//通过广播包数据，获取设备的mac地址
+ (NSString *)macString:(NSDictionary *)advData;

//通过广播包数据，获取设备的sn号
+ (NSString *)snString:(NSDictionary *)advData;


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
