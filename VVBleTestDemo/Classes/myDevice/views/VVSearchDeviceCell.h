//
//  VVSearchDeviceCell.h
//  VVBleManagerDemo
//
//  Created by zhx on 2020/6/5.
//  Copyright © 2020 inno. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <VVBleManager/VVBleManager.h>
NS_ASSUME_NONNULL_BEGIN

@interface VVSearchDeviceCell : UITableViewCell


@property (nonatomic , strong) VVBleDevice * device;

@end

NS_ASSUME_NONNULL_END
