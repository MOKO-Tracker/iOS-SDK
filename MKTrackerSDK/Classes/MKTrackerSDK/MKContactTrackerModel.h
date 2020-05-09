//
//  MKContactTrackerModel.h
//  MKContactTracker
//
//  Created by aa on 2020/4/24.
//  Copyright © 2020 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBPeripheral;
NS_ASSUME_NONNULL_BEGIN

@interface MKContactTrackerModel : NSObject

@property (nonatomic, strong)CBPeripheral *peripheral;

/// Current rssi of the device
@property (nonatomic, assign)NSInteger rssi;

/// Device name
@property (nonatomic, copy)NSString *deviceName;

@property (nonatomic, assign)NSInteger major;

@property (nonatomic, assign)NSInteger minor;

/// RSSI@1m
@property (nonatomic, assign)NSInteger rssi1m;

@property (nonatomic, assign)NSInteger txPower;

/// Battery voltage in mV
@property (nonatomic, assign)NSInteger batteryVoltage;

/// mac address
@property (nonatomic, copy)NSString *macAddress;

/// Whether the current device can be connected.
@property (nonatomic, assign)BOOL connectable;

/// Whether the device's scanning function is turned on.
@property (nonatomic, assign)BOOL track;

/// Far and near information, immediate (within 10cm), near (within 1m), far (within 1m), unknown (no signal)
@property (nonatomic, copy)NSString *proximity;

@end

NS_ASSUME_NONNULL_END
