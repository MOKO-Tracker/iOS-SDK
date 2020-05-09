//
//  MKContackTrackerPeripheral.m
//  MKContactTracker
//
//  Created by aa on 2020/4/25.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKContackTrackerPeripheral.h"
#import "CBPeripheral+MKContactTracker.h"

#import "MKContactTrackerSDKDefines.h"

@implementation MKContackTrackerPeripheral

- (void)discoverServices {
    NSArray *services = @[MKUUID(@"180F"),  //电池电量
                          MKUUID(@"180A"),  //厂商信息
                          MKUUID(@"FF00")]; //自定义
    [self.peripheral discoverServices:services];
}

- (void)discoverCharacteristics {
    for (CBService *service in self.peripheral.services) {
        if ([service.UUID isEqual:MKUUID(@"180F")]) {
            [self.peripheral discoverCharacteristics:@[MKUUID(@"2A19")] forService:service];
        }else if ([service.UUID isEqual:MKUUID(@"180A")]) {
            NSArray *characteristics = @[MKUUID(@"2A24"),MKUUID(@"2A25"),
                                         MKUUID(@"2A26"),MKUUID(@"2A27"),
                                         MKUUID(@"2A28"),MKUUID(@"2A29")];
            [self.peripheral discoverCharacteristics:characteristics forService:service];
        }else if ([service.UUID isEqual:MKUUID(@"FF00")]) {
            NSArray *characteristics = @[MKUUID(@"FF00"),MKUUID(@"FF01"),
                                         MKUUID(@"FF02"),MKUUID(@"FF03"),
                                         MKUUID(@"FF04"),MKUUID(@"FF05"),
                                         MKUUID(@"FF06"),MKUUID(@"FF07"),
                                         MKUUID(@"FF08"),MKUUID(@"FF09"),
                                         MKUUID(@"FF0A"),MKUUID(@"FF0B"),
                                         MKUUID(@"FF0C"),MKUUID(@"FF0D"),
                                         MKUUID(@"FF0E"),MKUUID(@"FF0F"),
                                         MKUUID(@"FF10")];
            [self.peripheral discoverCharacteristics:characteristics forService:service];
        }
    }
}

- (void)updateCharacterWithService:(CBService *)service {
    [self.peripheral updateCharacterWithService:service];
}

- (void)updateCurrentNotifySuccess:(CBCharacteristic *)characteristic {
    [self.peripheral updateCurrentNotifySuccess:characteristic];
}

- (BOOL)connectSuccess {
    return [self.peripheral connectSuccess];
}

- (void)setNil {
    [self.peripheral setNil];
}

@end
