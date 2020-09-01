//
//  VVMyDeviceViewController.m
//  VVBleManagerDemo
//
//  Created by zhx on 2020/6/5.
//  Copyright © 2020 inno. All rights reserved.
//

#import "VVMyDeviceViewController.h"
#import "VVSearchDeviceTableViewController.h"
#import "VVDeviceOperationViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface VVMyDeviceViewController ()
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *unbundlingButton;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIView *autoReconnectView;
@property (weak, nonatomic) IBOutlet UISwitch *autoReconnectFlag;

@property (nonatomic , strong)  NSDictionary * localDeviceInfo;

@end

@implementation VVMyDeviceViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registNotif];
    [self updateViewInfo];
}

- (void)registNotif{
    [[NSNotificationCenter defaultCenter] addObserverForName:VVNotification_peripheralDidConnect object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
        NSLog(@"------设备已连接 notifi:%@",note);
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:VVNotification_peripheralDidDisconnect object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
        NSLog(@"------设备断开连接 notifi:%@",note);
        if (self.localDeviceInfo) {
            
            [[VVBleManager shareManager] scanAndConnectToTargetDeviceMacAdress:self.localDeviceInfo[@"macAdress"] sn:self.localDeviceInfo[@"sn"] stop:10 succeed:^(VVBleDevice * _Nonnull device) {
                
                
            } error:^(NSError * _Nonnull error) {
                
            } disconnectToDevice:^(VVBleDevice * _Nonnull device, NSError * _Nonnull error) {
                
            }];
        }
    }];
    
}
- (void)updateViewInfo{
    //sn:104C000011A macAdress:69:9B:F3:7A:14:14
    self.localDeviceInfo = [VVBleAdvDataManagerTool getLocalDeviceInfoFromUserDefault];
    NSLog(@"info:%@",self.localDeviceInfo);
    
    if (self.localDeviceInfo) {
        
        self.infoLabel.text = [NSString stringWithFormat:@"macAdress:%@ sn:%@",self.localDeviceInfo[@"sn"],self.localDeviceInfo[@"macAdress"]];
        
        [self.searchButton setTitle:@"连接设备" forState:UIControlStateNormal];
        self.autoReconnectView.hidden = NO;
        self.unbundlingButton.hidden = NO;
    }else{
        
        self.infoLabel.text = @"暂无设备，请扫描绑定";
        [self.searchButton setTitle:@"绑定设备" forState:UIControlStateNormal];
        self.autoReconnectView.hidden = YES;
        self.unbundlingButton.hidden = YES;
    }
}

- (void)pushToSearchDeviceVC{
    VVSearchDeviceTableViewController * searchDeviceVC = [[VVSearchDeviceTableViewController alloc] init];
    
    
    [searchDeviceVC setBundlingAction:^(VVBleDevice * _Nonnull device) {
        [[VVBleManager shareManager] autoReconnectDevice:device];
        self.autoReconnectFlag.on = YES;
        [self updateViewInfo];
    }];
    [self.navigationController pushViewController:searchDeviceVC animated:YES];
}

- (void)pushToOperationVC:(VVBleDevice *)device{
    VVDeviceOperationViewController * deviceOperationVC = [[VVDeviceOperationViewController alloc] init];
    [self.navigationController pushViewController:deviceOperationVC animated:YES];
}

- (IBAction)searchDevice:(UIButton *)sender {
    
    if (self.localDeviceInfo) {
        
        VVBleManager * bleManager = [VVBleManager shareManager];
        __weak typeof(bleManager) weak_bleManager = bleManager;
        [bleManager scanAndConnectToTargetDeviceMacAdress:self.localDeviceInfo[@"macAdress"] sn:self.localDeviceInfo[@"sn"] stop:10 succeed:^(VVBleDevice * _Nonnull device) {
            
            //取消扫描
            [weak_bleManager stopScan];
            
            [self pushToOperationVC:device];
        } error:^(NSError * _Nonnull error) {
            
        } disconnectToDevice:^(VVBleDevice * _Nonnull device, NSError * _Nonnull error) {
            
        }];
    }else{
        [self pushToSearchDeviceVC];
    }
    
}

- (IBAction)unbundlingAction:(UIButton *)sender {
    [VVBleAdvDataManagerTool saveDeviceInfoToUserDefaultWithSn:nil macAdress:nil];
    
    [[VVBleManager shareManager] disconnectCurrentDevice];
    [self updateViewInfo];
}

- (IBAction)autoReconnectSwitchAction:(UISwitch *)sender {
    
    if (sender.isOn) {
        VVBleDevice * device = [VVBleDevice new];
        device.sn = self.localDeviceInfo[@"sn"];
        device.macAdress = self.localDeviceInfo[@"macAdress"];
        [[VVBleManager shareManager] autoReconnectDevice:device];
    }else{
        [[VVBleManager shareManager] autoReconnectCancel];
    }
    
}

@end




