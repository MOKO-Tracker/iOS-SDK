//
//  MKScanPageCell.h
//  MKContactTracker
//
//  Created by aa on 2020/4/22.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MKScanPageCellDelegate <NSObject>

/// 连接按钮点击事件
/// @param index 当前cell的row
- (void)scanCellConnectButtonPressed:(NSInteger)index;

@end

@interface MKScanPageCell : MKBaseCell

@property (nonatomic, strong)MKContactTrackerModel *dataModel;

@property (nonatomic, weak)id <MKScanPageCellDelegate>delegate;

+ (MKScanPageCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
