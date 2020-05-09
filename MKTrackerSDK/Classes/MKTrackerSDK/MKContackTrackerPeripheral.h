//
//  MKContackTrackerPeripheral.h
//  MKContactTracker
//
//  Created by aa on 2020/4/25.
//  Copyright © 2020 MK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKBLEBaseDataProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;
@interface MKContackTrackerPeripheral : NSObject<MKBLEBasePeripheralProtocol>

@property (nonatomic, strong, nonnull)CBPeripheral *peripheral;

@end

NS_ASSUME_NONNULL_END
