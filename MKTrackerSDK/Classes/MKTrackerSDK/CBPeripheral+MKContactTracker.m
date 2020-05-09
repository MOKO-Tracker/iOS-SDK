//
//  CBPeripheral+MKContactTracker.m
//  MKContactTracker
//
//  Created by aa on 2020/4/25.
//  Copyright © 2020 MK. All rights reserved.
//

#import "CBPeripheral+MKContactTracker.h"
#import <objc/runtime.h>

#import "MKContactTrackerSDKDefines.h"

static const char *batteryPowerKey = "batteryPowerKey";
static const char *manufacturerKey = "manufacturerKey";
static const char *deviceModelKey = "deviceModelKey";
static const char *productionDateKey = "productionDateKey";
static const char *hardwareKey = "hardwareKey";
static const char *softwareKey = "softwareKey";
static const char *firmwareKey = "firmwareKey";

static const char *deviceTypeKey = "deviceTypeKey";
static const char *uuidKey = "uuidKey";
static const char *majorKey = "majorKey";
static const char *minorKey = "minorKey";
static const char *measuredPowerKey = "measuredPowerKey";
static const char *txPowerKey = "txPowerKey";
static const char *broadcastIntervalKey = "broadcastIntervalKey";
static const char *deviceNameKey = "deviceNameKey";
static const char *passwordKey = "passwordKey";
static const char *batteryVoltageKey = "batteryVoltageKey";
static const char *scanStatusKey = "scanStatusKey";
static const char *connectableKey = "";
static const char *storageReminderKey = "storageReminderKey";
static const char *disconnectTypeKey = "disconnectTypeKey";
static const char *storageDataKey = "storageDataKey";
static const char *resetKey = "resetKey";
static const char *customKey = "customKey";

static const char *passwordNotifySuccessKey = "passwordNotifySuccessKey";
static const char *customNotifySuccessKey = "customNotifySuccessKey";

@implementation CBPeripheral (MKContactTracker)

/*
 
 */

#pragma mark - public method
- (void)updateCharacterWithService:(CBService *)service {
    NSArray *characteristicList = service.characteristics;
    if ([service.UUID isEqual:MKUUID(@"180F")]) {
        //电池电量
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:MKUUID(@"2A19")]) {
                objc_setAssociatedObject(self, &batteryPowerKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                break;
            }
        }
        return;
    }
    if ([service.UUID isEqual:MKUUID(@"180A")]) {
        //设备信息
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:MKUUID(@"2A24")]) {
                objc_setAssociatedObject(self, &deviceModelKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"2A25")]) {
                objc_setAssociatedObject(self, &productionDateKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"2A26")]) {
                objc_setAssociatedObject(self, &firmwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"2A27")]) {
                objc_setAssociatedObject(self, &hardwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"2A28")]) {
                objc_setAssociatedObject(self, &softwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"2A29")]) {
                objc_setAssociatedObject(self, &manufacturerKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        return;
    }
    if ([service.UUID isEqual:MKUUID(@"FF00")]) {
        //自定义服务
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:MKUUID(@"FF00")]) {
                objc_setAssociatedObject(self, &deviceTypeKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF01")]) {
                objc_setAssociatedObject(self, &uuidKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF02")]) {
                objc_setAssociatedObject(self, &majorKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF03")]) {
                objc_setAssociatedObject(self, &minorKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF04")]) {
                objc_setAssociatedObject(self, &measuredPowerKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF05")]) {
                objc_setAssociatedObject(self, &txPowerKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF06")]) {
                objc_setAssociatedObject(self, &broadcastIntervalKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF07")]) {
                objc_setAssociatedObject(self, &deviceNameKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF08")]) {
                objc_setAssociatedObject(self, &passwordKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [self setNotifyValue:YES forCharacteristic:characteristic];
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF09")]) {
                objc_setAssociatedObject(self, &batteryVoltageKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF0A")]) {
                objc_setAssociatedObject(self, &scanStatusKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF0B")]) {
                objc_setAssociatedObject(self, &connectableKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF0C")]) {
                objc_setAssociatedObject(self, &storageReminderKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF0D")]) {
                objc_setAssociatedObject(self, &disconnectTypeKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF0E")]) {
                objc_setAssociatedObject(self, &storageDataKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF0F")]) {
                objc_setAssociatedObject(self, &resetKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:MKUUID(@"FF10")]) {
                objc_setAssociatedObject(self, &customKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [self setNotifyValue:YES forCharacteristic:characteristic];
            }
        }
        return;
    }
}

- (void)updateCurrentNotifySuccess:(CBCharacteristic *)characteristic {
    if ([characteristic.UUID isEqual:MKUUID(@"FF08")]) {
        objc_setAssociatedObject(self, &passwordNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:MKUUID(@"FF10")]) {
        objc_setAssociatedObject(self, &customNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
}

- (BOOL)connectSuccess {
    if (![objc_getAssociatedObject(self, &customNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &passwordNotifySuccessKey) boolValue]) {
        return NO;
    }
    if (!self.batteryPower || !self.manufacturer || !self.deviceModel
        || !self.productionDate || !self.hardware || !self.sofeware || !self.firmware) {
        return NO;
    }
    if (!self.deviceType || !self.uuid || !self.major || !self.minor || !self.measuredPower || !self.broadcastInterval || !self.deviceName || !self.password || !self.batteryVoltage || !self.scanStatus || !self.storageReminder || !self.disconnectType || !self.storageData || !self.reset || !self.custom) {
        return NO;
    }
    return YES;
}

- (void)setNil {
    objc_setAssociatedObject(self, &batteryPowerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &manufacturerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &deviceModelKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &productionDateKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &hardwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &softwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &firmwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &deviceTypeKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &uuidKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &majorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &minorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &measuredPowerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &broadcastIntervalKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &deviceNameKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &passwordKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &batteryVoltageKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &scanStatusKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &storageReminderKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &disconnectTypeKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &storageDataKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &resetKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &customKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &passwordNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &customNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getter

- (CBCharacteristic *)batteryPower {
    return objc_getAssociatedObject(self, &batteryPowerKey);
}

- (CBCharacteristic *)manufacturer {
    return objc_getAssociatedObject(self, &manufacturerKey);
}

- (CBCharacteristic *)deviceModel {
    return objc_getAssociatedObject(self, &deviceModelKey);
}

- (CBCharacteristic *)productionDate {
    return objc_getAssociatedObject(self, &productionDateKey);
}

- (CBCharacteristic *)hardware {
    return objc_getAssociatedObject(self, &hardwareKey);
}

- (CBCharacteristic *)sofeware {
    return objc_getAssociatedObject(self, &softwareKey);
}

- (CBCharacteristic *)firmware {
    return objc_getAssociatedObject(self, &firmwareKey);
}

- (CBCharacteristic *)deviceType {
    return objc_getAssociatedObject(self, &deviceTypeKey);
}

- (CBCharacteristic *)uuid {
    return objc_getAssociatedObject(self, &uuidKey);
}

- (CBCharacteristic *)major {
    return objc_getAssociatedObject(self, &majorKey);
}

- (CBCharacteristic *)minor {
    return objc_getAssociatedObject(self, &minorKey);
}

- (CBCharacteristic *)measuredPower {
    return objc_getAssociatedObject(self, &measuredPowerKey);
}

- (CBCharacteristic *)txPower {
    return objc_getAssociatedObject(self, &txPowerKey);
}

- (CBCharacteristic *)broadcastInterval {
    return objc_getAssociatedObject(self, &broadcastIntervalKey);
}

- (CBCharacteristic *)deviceName {
    return objc_getAssociatedObject(self, &deviceNameKey);
}

- (CBCharacteristic *)password {
    return objc_getAssociatedObject(self, &passwordKey);
}

- (CBCharacteristic *)batteryVoltage {
    return objc_getAssociatedObject(self, &batteryVoltageKey);
}

- (CBCharacteristic *)scanStatus {
    return objc_getAssociatedObject(self, &scanStatusKey);
}

- (CBCharacteristic *)connectable {
    return objc_getAssociatedObject(self, &connectableKey);
}

- (CBCharacteristic *)storageReminder {
    return objc_getAssociatedObject(self, &storageReminderKey);
}

- (CBCharacteristic *)disconnectType {
    return objc_getAssociatedObject(self, &disconnectTypeKey);
}

- (CBCharacteristic *)storageData {
    return objc_getAssociatedObject(self, &storageDataKey);
}

- (CBCharacteristic *)reset {
    return objc_getAssociatedObject(self, &resetKey);
}

- (CBCharacteristic *)custom {
    return objc_getAssociatedObject(self, &customKey);
}

@end
