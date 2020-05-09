//
//  MKBLEOperation.h
//  MKContactTracker
//
//  Created by aa on 2020/4/27.
//  Copyright © 2020 MK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKBLEOperationID.h"
#import "MKBLEBaseDataProtocol.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const mk_additionalInformation;
extern NSString *const mk_dataInformation;
extern NSString *const mk_dataStatusLev;

@interface MKBLEOperation : NSOperation<MKBLEBaseOperationProtocol>

/**
 接受定时器超时时间，默认为2s
 */
@property (nonatomic, assign)NSTimeInterval receiveTimeout;

/**
 初始化通信线程
 
 @param operationID 当前线程的任务ID
 @param resetNum 是否需要根据外设返回的数据总条数来修改任务需要接受的数据总条数，YES需要，NO不需要
 @param commandBlock 发送命令回调
 @param completeBlock 数据通信完成回调
 @return operation
 */
- (instancetype)initOperationWithID:(mk_taskOperationID)operationID
                           resetNum:(BOOL)resetNum
                       commandBlock:(void (^)(void))commandBlock
                      completeBlock:(void (^)(NSError *error, mk_taskOperationID operationID, id returnData))completeBlock;

@end

NS_ASSUME_NONNULL_END
