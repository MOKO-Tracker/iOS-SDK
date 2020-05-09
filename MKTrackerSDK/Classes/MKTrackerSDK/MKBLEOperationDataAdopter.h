//
//  MKBLEOperationDataAdopter.h
//  MKBLEBaseModule_Example
//
//  Created by aa on 2019/11/19.
//  Copyright © 2019 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const mk_communicationDataNum;

@class CBCharacteristic;
@interface MKBLEOperationDataAdopter : NSObject

+ (NSDictionary *)parseReadDataWithCharacteristic:(CBCharacteristic *)characteristic;

+ (NSDictionary *)parseWriteDataWithCharacteristic:(CBCharacteristic *)characteristic;

@end

NS_ASSUME_NONNULL_END
