//
//  MKFilterOptionsModel.h
//  MKContactTracker
//
//  Created by aa on 2020/4/24.
//  Copyright © 2020 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKFilterOptionsModel : NSObject

@property (nonatomic, assign)NSInteger rssiValue;

@property (nonatomic, assign)BOOL advDataFilterIson;

@property (nonatomic, assign)BOOL macIson;

@property (nonatomic, copy)NSString *macValue;

@property (nonatomic, assign)BOOL advNameIson;

@property (nonatomic, copy)NSString *advNameValue;

@property (nonatomic, assign)BOOL uuidIson;

@property (nonatomic, copy)NSString *uuidValue;

@property (nonatomic, assign)BOOL majorIson;

/// 对于不支持新功能(V3.0.0版本的设备)的设备来说，使用这个过滤值
@property (nonatomic, copy)NSString *majorValue;

/// 对于支持新功能(V3.1.0以上)的设备来说，过滤的Major可以是一个范围值
@property (nonatomic, copy)NSString *majorMaxValue;

/// 对于支持新功能(V3.1.0以上)的设备来说，过滤的Major可以是一个范围值
@property (nonatomic, copy)NSString *majorMinValue;

@property (nonatomic, assign)BOOL minorIson;

/// 对于不支持新功能(V3.0.0版本的设备)的设备来说，使用这个过滤值
@property (nonatomic, copy)NSString *minorValue;

//对于支持新功能(V3.1.0以上)的设备来说，过滤的Minor可以是一个范围值
@property (nonatomic, copy)NSString *minorMaxValue;

//对于支持新功能(V3.1.0以上)的设备来说，过滤的Minor可以是一个范围值
@property (nonatomic, copy)NSString *minorMinValue;

@property (nonatomic, assign)BOOL rawDataIson;

@property (nonatomic, copy)NSString *rawDataValue;

- (void)startReadDataWithSucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

- (void)startConfigDataWithSucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
