//
//  MKScannerDataModel.h
//  MKContactTracker
//
//  Created by aa on 2020/4/29.
//  Copyright © 2020 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKScannerDataModel : NSObject

@property (nonatomic, copy)NSString *interval;

/// 0:储存提醒关闭,1:打开LED提醒；2:打开马达提醒；3:LED和马达提醒都打开；
@property (nonatomic, assign)NSInteger trackingNote;

@property (nonatomic, strong)NSDictionary *conditions;

/// 震动次数
@property (nonatomic, assign)NSInteger vibNubmer;

- (void)updateWithDataModel:(MKScannerDataModel *)model;

- (void)startReadDatasWithSucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

- (void)startConfigDatas:(MKScannerDataModel *)dataModel
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
