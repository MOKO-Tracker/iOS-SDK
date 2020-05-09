//
//  CBPeripheral+MKContactTracker.h
//  MKContactTracker
//
//  Created by aa on 2020/4/25.
//  Copyright © 2020 MK. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBPeripheral (MKContactTracker)

#pragma mark - Read only

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *batteryPower;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *manufacturer;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *deviceModel;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *productionDate;

@property (nonatomic, strong, readonly)CBCharacteristic *hardware;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *sofeware;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *firmware;

#pragma mark - custom

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *deviceType;

/// R/W
@property (nonatomic, strong, readonly)CBCharacteristic *uuid;

/// R/W
@property (nonatomic, strong, readonly)CBCharacteristic *major;

/// R/W
@property (nonatomic, strong, readonly)CBCharacteristic *minor;

/// R/W
@property (nonatomic, strong, readonly)CBCharacteristic *measuredPower;

/// R/W
@property (nonatomic, strong, readonly)CBCharacteristic *txPower;

/// R/W
@property (nonatomic, strong, readonly)CBCharacteristic *broadcastInterval;

/// R/W
@property (nonatomic, strong, readonly)CBCharacteristic *deviceName;

/// N/W
@property (nonatomic, strong, readonly)CBCharacteristic *password;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *batteryVoltage;

/// R/W
@property (nonatomic, strong, readonly)CBCharacteristic *scanStatus;

/// R/W
@property (nonatomic, strong, readonly)CBCharacteristic *connectable;

/// R/W
@property (nonatomic, strong, readonly)CBCharacteristic *storageReminder;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *disconnectType;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *storageData;

/// W
@property (nonatomic, strong, readonly)CBCharacteristic *reset;

/// N/W
@property (nonatomic, strong, readonly)CBCharacteristic *custom;

- (void)updateCharacterWithService:(CBService *)service;

- (void)updateCurrentNotifySuccess:(CBCharacteristic *)characteristic;

- (BOOL)connectSuccess;

- (void)setNil;

@end

NS_ASSUME_NONNULL_END
