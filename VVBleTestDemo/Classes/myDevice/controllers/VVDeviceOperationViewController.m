//
//  VVDeviceOperationViewController.m
//  VVBleManagerDemo
//
//  Created by zhx on 2020/6/11.
//  Copyright © 2020 inno. All rights reserved.
//

#import "VVDeviceOperationViewController.h"

@interface VVDeviceOperationViewController ()
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
@property (weak, nonatomic) IBOutlet UITextField *minTextFieldView;
@property (weak, nonatomic) IBOutlet UITextField *maxTextFieldView;
@property (weak, nonatomic) IBOutlet UITextField *numbersHistoryDataTextFieldView;


@property (nonatomic , strong) VVBleDevice * device;

@end

@implementation VVDeviceOperationViewController

- (void)dealloc{
    NSLog(@"----dealloc--- %@",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registNotifi];
    self.device = [VVBleManager shareManager].currentDevice;
}
- (void)registNotifi{
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:VVNotification_didReadPOCTData object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
       
        NSDictionary * polishData = note.object;
        NSString *state = [polishData objectForKey:VVKey_POCTDataStateCode];
        VVPOCTStateCode stateCode = [state integerValue];
        if (stateCode == VVPOCTStateCode_pleaseInputPaper) {
            
            VVBleLog(@"please input paper");
        }else if (stateCode == VVPOCTStateCode_inputPaper ||
                  stateCode == VVPOCTStateCode_ketonInputPaper) {
            
            VVBleLog(@"intputed paper");
        }else if (stateCode == VVPOCTStateCode_pleaseInputBlood ||
                  stateCode == VVPOCTStateCode_ketonPleasInputBlood) {
            
            VVBleLog(@"please input blood");
        }else if (stateCode == VVPOCTStateCode_waitingResult ||
                  stateCode == VVPOCTStateCode_ketonWaitingResult) {
            
            VVBleLog(@"waiting result");
        }else if (stateCode == VVPOCTStateCode_result ||
                  stateCode == VVPOCTStateCode_ketonResult) {
            //
            NSNumber *numberValue = [polishData objectForKey:VVKey_GlucoValue];
            NSString * deviceUnit = [polishData objectForKey:VVKey_deviceUnitType];
            NSString *warStr = [NSString stringWithFormat:@"%@:%.1f%@",@"测量结果",[numberValue floatValue],deviceUnit];
            
            VVBleLog(@"%@",warStr);
        }
        
        weakSelf.infoTextView.text = [NSString stringWithFormat:@"synch test response data polisData:%@",polishData];
    }];
}

- (IBAction)readAllHistoryData:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    
    [[VVBleManager shareManager].currentDevice sendFixedDataCommand:VVCommandType_ReadHistoryData receiveData:^(VVCommandType commandType, NSData * _Nonnull originalData, NSDictionary * _Nonnull polishData) {
        
        NSString * string = [NSString stringWithFormat:@"---ReadTargetValue--- device:%@ \ncommandType:%lu \noriginalData:%@ \npolistData:%@",weakSelf.device,(unsigned long)commandType,originalData,polishData];
        VVBleLog(@"%@",string);
        
        weakSelf.infoTextView.text = string;
    } writeDataSucceed:^{
        
    } error:^(NSError * _Nonnull error) {
        VVBleLog(@"error:%@",error);
        
        weakSelf.infoTextView.text = [NSString stringWithFormat:@"error:%@",error];
    }];
}

- (IBAction)readDeviceSoftVersion:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [self.device sendFixedDataCommand:VVCommandType_ReadDeviceInfoTargetVersion receiveData:^(VVCommandType commandType, NSData * _Nonnull originalData, NSDictionary * _Nonnull polishData) {
        
        NSString * string = [NSString stringWithFormat:@"---ReadTargetValue--- device:%@ \ncommandType:%lu \noriginalData:%@ \npolistData:%@",weakSelf.device,(unsigned long)commandType,originalData,polishData];
        VVBleLog(@"%@",string);
        
        weakSelf.infoTextView.text = string;
    } writeDataSucceed:^{
           
    } error:^(NSError *error) {
        
        VVBleLog(@"error:%@",error);
        
        weakSelf.infoTextView.text = [NSString stringWithFormat:@"error:%@",error];
    }];
}

- (IBAction)deleteAllHistoryData:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [self.device sendFixedDataCommand:VVCommandType_DeleteAllHistoryData receiveData:^(VVCommandType commandType, NSData * _Nonnull originalData, NSDictionary * _Nonnull polishData) {
        
        NSString * string = [NSString stringWithFormat:@"---deleteAllHistoryData--- device:%@ \ncommandType:%lu \noriginalData:%@ \npolistData:%@",weakSelf.device,(unsigned long)commandType,originalData,polishData];
        VVBleLog(@"%@",string);
        
        weakSelf.infoTextView.text = string;
    } writeDataSucceed:^{
        
    } error:^(NSError * _Nonnull error) {
        VVBleLog(@"error:%@",error);
        
        weakSelf.infoTextView.text = [NSString stringWithFormat:@"error:%@",error];
    }];
}

- (IBAction)deleteSingleHistoryData:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [self.device sendFixedDataCommand:VVCommandType_DeleteSingleHistoryData receiveData:^(VVCommandType commandType, NSData * _Nonnull originalData, NSDictionary * _Nonnull polishData) {
        
        NSString * string = [NSString stringWithFormat:@"---deleteSingleHistoryData--- device:%@ \ncommandType:%lu \noriginalData:%@ \npolistData:%@",weakSelf.device,(unsigned long)commandType,originalData,polishData];
        VVBleLog(@"%@",string);
        
        weakSelf.infoTextView.text = string;
    } writeDataSucceed:^{
        
    } error:^(NSError * _Nonnull error) {
        VVBleLog(@"error:%@",error);
        
        weakSelf.infoTextView.text = [NSString stringWithFormat:@"error:%@",error];
    }];
}

- (IBAction)readTargetMinMaxValue:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    
    [self.device sendFixedDataCommand:VVCommandType_ReadTargetValue receiveData:^(VVCommandType commandType, NSData * _Nonnull originalData, NSDictionary * _Nonnull polishData) {
        
    } writeDataSucceed:^{
              
    } error:^(NSError *error) {
        VVBleLog(@"error:%@",error);
        
        weakSelf.infoTextView.text = [NSString stringWithFormat:@"error:%@",error];
    }];
}

- (IBAction)setupTargetMinMaxValue:(UIButton *)sender {
    
    CGFloat min = [self.minTextFieldView.text floatValue];
    CGFloat max = [self.maxTextFieldView.text floatValue];
    
    __weak typeof(self) weakSelf = self;
    [self.device commandSetupTargetValueMin:min max:max receiveDataBlock:^(VVCommandType commandType, NSData * _Nonnull originalData, NSDictionary * _Nonnull polishData) {
        
        
        NSString * string = [NSString stringWithFormat:@"---SetupTargetValue--- device:%@ \ncommandType:%lu \noriginalData:%@ \npolistData:%@",weakSelf.device,(unsigned long)commandType,originalData,polishData];
        VVBleLog(@"%@",string);
        weakSelf.infoTextView.text = string;
    } writeDataSucceed:^{
        
    } error:^(NSError * _Nonnull error) {
        VVBleLog(@"error:%@",error);
        
        weakSelf.infoTextView.text = [NSString stringWithFormat:@"error:%@",error];
    }];
}

- (IBAction)readGKIHistoryData:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    [self.device sendFixedDataCommand:VVCommandType_ReadGKIHistoryData receiveData:^(VVCommandType commandType, NSData * _Nonnull originalData, NSDictionary * _Nonnull polishData) {
       
        NSString * string = [NSString stringWithFormat:@"---ReadGKIHistoryData--- device:%@ \ncommandType:%lu \noriginalData:%@ \npolistData:%@",weakSelf.device,(unsigned long)commandType,originalData,polishData];
        VVBleLog(@"%@",string);
        weakSelf.infoTextView.text = string;
    } writeDataSucceed:^{
                 
    } error:^(NSError *error) {
        VVBleLog(@"error:%@",error);
        
        weakSelf.infoTextView.text = [NSString stringWithFormat:@"error:%@",error];
    }];
}

- (IBAction)readNumbersHistoryData:(id)sender {
    NSUInteger numbers = [self.numbersHistoryDataTextFieldView.text intValue];
    
    __weak typeof(self) weakSelf = self;
    [self.device commandReadHistoryDataNumber:numbers receiveData:^(VVCommandType commandType, NSData * _Nonnull originalData, NSDictionary * _Nonnull polishData) {
        
        NSString * string = [NSString stringWithFormat:@"---ReadHistoryDataNumber--- device:%@ \ncommandType:%lu \noriginalData:%@ \npolistData:%@",weakSelf.device,(unsigned long)commandType,originalData,polishData];
        VVBleLog(@"%@",string);
        weakSelf.infoTextView.text = string;
        
    } writeDataSucceed:^{
        
    } error:^(NSError * _Nonnull error) {
        VVBleLog(@"error:%@",error);
        
        weakSelf.infoTextView.text = [NSString stringWithFormat:@"error:%@",error];
    }];
}

@end
