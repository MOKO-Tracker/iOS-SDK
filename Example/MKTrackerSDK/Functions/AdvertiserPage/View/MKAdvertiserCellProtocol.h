//
//  MKAdvertiserCellProtocol.h
//  MKContactTracker
//
//  Created by aa on 2020/4/28.
//  Copyright © 2020 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKAdvertiserCellDelegate <NSObject>

- (void)advertiserParamsChanged:(id)newValue indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
