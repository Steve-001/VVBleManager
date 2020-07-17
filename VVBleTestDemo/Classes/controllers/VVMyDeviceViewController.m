//
//  VVMyDeviceViewController.m
//  VVBleManagerDemo
//
//  Created by zhx on 2020/6/5.
//  Copyright © 2020 inno. All rights reserved.
//

#import "VVMyDeviceViewController.h"
#import "VVSearchDeviceTableViewController.h"


@interface VVMyDeviceViewController ()
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;


@end

@implementation VVMyDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
}



- (IBAction)searchDevice:(UIButton *)sender {
    
    
    VVSearchDeviceTableViewController * searchDeviceVC = [[VVSearchDeviceTableViewController alloc] init];
    
    [self.navigationController pushViewController:searchDeviceVC animated:YES];
}

@end


