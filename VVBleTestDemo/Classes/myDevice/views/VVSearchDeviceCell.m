//
//  VVSearchDeviceCell.m
//  VVBleManagerDemo
//
//  Created by zhx on 2020/6/5.
//  Copyright © 2020 inno. All rights reserved.
//

#import "VVSearchDeviceCell.h"
@interface VVSearchDeviceCell ()

@property (weak, nonatomic) IBOutlet UILabel *infofLabel;


@end
@implementation VVSearchDeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setDevice:(VVBleDevice *)device{
    _device = device;
    
    NSString * text = [NSString stringWithFormat:@"name:%@ sn:%@ mac:%@",device.name,device.sn,device.macAdress];
    self.infofLabel.text = text;
}
@end
