//
//  VVSearchDeviceTableViewController.h
//  VVBleManagerDemo
//
//  Created by zhx on 2020/6/5.
//  Copyright © 2020 inno. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VVSearchDeviceCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface VVSearchDeviceTableViewController : UIViewController

@property (nonatomic , copy) void (^bundlingAction) (VVBleDevice * device);

@end

NS_ASSUME_NONNULL_END
