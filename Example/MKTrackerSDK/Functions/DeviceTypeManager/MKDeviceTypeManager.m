//
//  MKDeviceTypeManager.m
//  MKContactTracker
//
//  Created by aa on 2020/6/30.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKDeviceTypeManager.h"

#import "MKConfigDateModel.h"

static MKDeviceTypeManager *manager = nil;

@interface MKDeviceTypeManager ()

@property (nonatomic, strong)dispatch_queue_t connectQueue;

@property (nonatomic, strong)dispatch_semaphore_t connectSemaphore;

/// MKiBeacon-V3.1.0
@property (nonatomic, copy)NSString *firmware;

@property (nonatomic, assign)BOOL supportNewCommand;

@property (nonatomic, copy)NSString *deviceType;

@property (nonatomic, assign)BOOL supportAdvTrigger;

@property (nonatomic, copy)NSString *password;

@end

@implementation MKDeviceTypeManager

+ (MKDeviceTypeManager *)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [MKDeviceTypeManager new];
        }
    });
    return manager;
}

- (void)connectTracker:(MKContactTrackerModel *)trackerModel
              password:(NSString *)password
         completeBlock:(void (^)(NSError *error,BOOL supportNewCommand))completeBlock {
    [self setDefaultParams];
    dispatch_async(self.connectQueue, ^{
        if (![self connectDevice:trackerModel password:password]) {
            [self operationFailedMsg:@"Connect Failed" completeBlock:completeBlock];
            return ;
        }
        NSString *deviceType = [self readTrackerType];
        if (![deviceType isEqualToString:@"04"] && ![deviceType isEqualToString:@"05"] && ![deviceType isEqualToString:@"06"] && ![deviceType isEqualToString:@"07"]) {
            [self operationFailedMsg:@"Oops! Something went wrong. Please check the device version or contact MOKO." completeBlock:completeBlock];
            return ;
        }
        self.deviceType = deviceType;
        self.supportAdvTrigger = ([deviceType isEqualToString:@"05"] || [deviceType isEqualToString:@"07"]);
        if (![self configDate]) {
            [self operationFailedMsg:@"Config date error" completeBlock:completeBlock];
            return;
        }
        self.firmware = [self readFirmwareVersion];
        if (!ValidStr(self.firmware)) {
            [self operationFailedMsg:@"Read firmware error" completeBlock:completeBlock];
            return;
        }
        [self updateSupportNewCommand];
        if (self.supportNewCommand) {
            if (![self sendVibrationCommandsToDevice]) {
                [self operationFailedMsg:@"Vibration error" completeBlock:completeBlock];
                return;
            }
        }
        self.password = password;
        moko_dispatch_main_safe(^{
            if (completeBlock) {
                completeBlock(nil,self.supportNewCommand);
            }
        });
    });
}

#pragma mark - interface
- (BOOL)connectDevice:(MKContactTrackerModel *)trackerModel password:(NSString *)password {
    __block BOOL success = NO;
    [[MKContactTrackerCentralManager shared] connectDevice:trackerModel password:password sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        success = YES;
        dispatch_semaphore_signal(self.connectSemaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.connectSemaphore);
    }];
    dispatch_semaphore_wait(self.connectSemaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (NSString *)readTrackerType {
    __block NSString *type = @"";
    [MKTrackerInterface readTrackerDeviceTypeWithSucBlock:^(id  _Nonnull returnData) {
        type = returnData[@"result"][@"deviceType"];
        dispatch_semaphore_signal(self.connectSemaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.connectSemaphore);
    }];
    dispatch_semaphore_wait(self.connectSemaphore, DISPATCH_TIME_FOREVER);
    return type;
}

- (BOOL)configDate {
    __block BOOL success = NO;
    MKConfigDateModel *dateModel = [MKConfigDateModel fetchCurrentTime];
    [MKTrackerInterface configDeviceTime:dateModel sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.connectSemaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.connectSemaphore);
    }];
    dispatch_semaphore_wait(self.connectSemaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)sendVibrationCommandsToDevice {
    __block BOOL success = NO;
    [MKTrackerInterface sendVibrationCommandsToDeviceWithSucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.connectSemaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.connectSemaphore);
    }];
    dispatch_semaphore_wait(self.connectSemaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (NSString *)readFirmwareVersion {
    __block NSString *firmware = @"";
    [MKTrackerInterface readFirmwareWithSucBlock:^(id  _Nonnull returnData) {
        firmware = returnData[@"result"][@"firmware"];
        dispatch_semaphore_signal(self.connectSemaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.connectSemaphore);
    }];
    dispatch_semaphore_wait(self.connectSemaphore, DISPATCH_TIME_FOREVER);
    return firmware;
}

- (void)updateSupportNewCommand {
    if (!ValidStr(self.firmware)) {
        return;
    }
    //self.firmware = MKiBeacon-V3.1.0
    //versionList = @[@"MKiBeacon",@"V3.1.0"];
    NSArray *versionList = [self.firmware componentsSeparatedByString:@"-"];
    NSString *tempVersion = [versionList lastObject];
    tempVersion = [tempVersion stringByReplacingOccurrencesOfString:@"V" withString:@""];
    tempVersion = [tempVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    self.supportNewCommand = ([tempVersion integerValue] >= 310);
}

#pragma mark - private method
- (void)setDefaultParams {
    self.firmware = @"";
    self.supportNewCommand = NO;
    self.deviceType = @"";
    self.supportAdvTrigger = NO;
}

- (NSError *)fetchErrorWithMsg:(NSString *)msg {
    NSError *error = [[NSError alloc] initWithDomain:@"connectDevice"
                                                code:-999
                                            userInfo:@{@"errorInfo":SafeStr(msg)}];
    return error;
}

- (void)operationFailedMsg:(NSString *)msg completeBlock:(void (^)(NSError *error,BOOL supportNewCommand))block {
    moko_dispatch_main_safe(^{
        [self setDefaultParams];
        [[MKContactTrackerCentralManager shared] disconnect];
        if (block) {
            block([self fetchErrorWithMsg:msg],NO);
        }
    });
}

#pragma mark - getter
- (dispatch_queue_t)connectQueue {
    if (!_connectQueue) {
        _connectQueue = dispatch_queue_create("com.moko.connectQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _connectQueue;
}

- (dispatch_semaphore_t)connectSemaphore {
    if (!_connectSemaphore) {
        _connectSemaphore = dispatch_semaphore_create(0);
    }
    return _connectSemaphore;
}

@end
