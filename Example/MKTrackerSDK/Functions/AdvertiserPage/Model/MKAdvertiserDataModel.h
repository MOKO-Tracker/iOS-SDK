//
//  MKAdvertiserDataModel.h
//  MKContactTracker
//
//  Created by aa on 2020/4/28.
//  Copyright © 2020 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKAdvertiserDataModel : NSObject

@property (nonatomic, copy)NSString *deviceName;

@property (nonatomic, copy)NSString *proximityUUID;

@property (nonatomic, copy)NSString *major;

@property (nonatomic, copy)NSString *minor;

@property (nonatomic, copy)NSString *interval;

@property (nonatomic, copy)NSString *measurePower;

@property (nonatomic, copy)NSString *txPower;

@property (nonatomic, strong)NSDictionary *advTriggerConditions;

- (void)updateValueWithModel:(MKAdvertiserDataModel *)model;

- (void)startReadDatasWithSucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

- (void)startConfigDatas:(MKAdvertiserDataModel *)dataModel
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
