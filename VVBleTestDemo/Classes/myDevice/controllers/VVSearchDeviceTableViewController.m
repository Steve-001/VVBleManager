//
//  VVSearchDeviceTableViewController.m
//  VVBleManagerDemo
//
//  Created by zhx on 2020/6/5.
//  Copyright © 2020 inno. All rights reserved.
//

#import "VVSearchDeviceTableViewController.h"
#import "VVDeviceOperationViewController.h"




@interface VVSearchDeviceTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *bleStateLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic , strong) NSMutableArray * searchedDevices;
@property (nonatomic , strong) VVBleManager * bleManager;


@end

@implementation VVSearchDeviceTableViewController

#pragma mark system
- (void)dealloc{
    VVBleLog(@"----dealloc--- %@",NSStringFromClass([self class]));
    [[VVBleManager shareManager] stopScan];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
    [self.tableView registerNib:[UINib nibWithNibName:@"VVSearchDeviceCell" bundle:nil] forCellReuseIdentifier:@"VVSearchDeviceCell"];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"scan" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    VVBleManager * manager = [VVBleManager shareManager];
    __weak typeof(self) weakSelf = self;
    [manager setManagerDidUpdateStateBlock:^(CBCentralManager * central) {
        [weakSelf updateLabelState:central.state];
        if (central.state == CBManagerStatePoweredOn) {
            [weakSelf scanDevice];
        }
    }];
    self.bleManager = manager;
    [self scanDevice];
}

- (void)vv_dismissVC{
    if (self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)updateLabelState:(CBManagerState)state{
    self.bleStateLabel.text = VVBleStateDescriptionStringFromState(state);
}

- (void)rightItemAction:(UIBarButtonItem *)sender{
    [self scanDevice];
}

- (void)scanDevice{
    [self.searchedDevices removeAllObjects];
    [self.tableView reloadData];
    
    __weak typeof(self) weakSelf = self;
    [self.bleManager scanAllAvailableVivachekDeviceStop:5 complete:^(VVBleDevice * _Nullable device, NSError * _Nullable error) {
        if(error){
//            NSLog(@"------scanDeviceError----- error:%@",error);
        }
        
        CBManagerState state = CBManagerStatePoweredOn;
        if (error.code == VVBleErrorCode_bleStateUnavailable) {
            
            NSDictionary * errorInfo = error.userInfo;
            
            state = CBManagerStatePoweredOff;
        }
        [weakSelf updateLabelState:state];
        
        if (device) {
//            NSLog(@"-------searchedDevice-------  device:%@",device);
            
            [weakSelf updateListDevice:device];
        }
    }];
}


- (void)updateListDevice:(VVBleDevice *)device{
    
    for (VVBleDevice *deviceModel in self.searchedDevices) {
        NSString *perUUID = deviceModel.peripheral.identifier.UUIDString;
        if ([perUUID isEqualToString:device.peripheral.identifier.UUIDString]) {
            return;
        }
    }
    [self.searchedDevices addObject:device];
    [self.tableView reloadData];
}

#pragma mark getter
- (NSMutableArray *)searchedDevices{
    if (!_searchedDevices) {
        _searchedDevices = [NSMutableArray new];
    }
    return _searchedDevices;
}

#pragma mark - Tableviewdatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchedDevices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VVSearchDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VVSearchDeviceCell" forIndexPath:indexPath];
    
    cell.device = self.searchedDevices[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.bleManager stopScan];
    VVBleDevice * device = self.searchedDevices[indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    [self.bleManager connectToDevice:device succeed:^(VVBleDevice * _Nonnull device) {
        
        VVBleLog(@"-----connectSucceed----- device:%@",device);
        //本地化设备信息
        [VVBleAdvDataManagerTool saveDeviceInfoToUserDefaultWithSn:device.sn macAdress:device.macAdress];
        
        [weakSelf pushTODeviceOperationVCDevice:device];
        
    } error:^(NSError * _Nullable error) {
        
        VVBleLog(@"-----connectFail----- device:%@ error:%@",device,error);
        
    } disconnectToDevice:^(VVBleDevice * _Nonnull device, NSError * _Nonnull error) {
        
        VVBleLog(@"-----disconnectToDevice----- device:%@ error:%@",device,error);
    }];
    
}

- (void)pushTODeviceOperationVCDevice:(VVBleDevice *)device{
    
    if (self.bundlingAction) {
        self.bundlingAction(device);
    }
    [self.navigationController popViewControllerAnimated:YES];
}



@end
