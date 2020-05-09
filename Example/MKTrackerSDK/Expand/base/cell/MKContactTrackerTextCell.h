//
//  MKContactTrackerTextCell.h
//  MKContactTracker
//
//  Created by aa on 2020/4/23.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKContactTrackerTextCellModel : NSObject

/// 左侧label
@property (nonatomic, copy)NSString *leftMsg;

/// 是否显示右侧箭头，如果显示，则rightMsg不会显示
@property (nonatomic, assign)BOOL showRightIcon;

/// 右侧label
@property (nonatomic, copy)NSString *rightMsg;

@end

@interface MKContactTrackerTextCell : MKBaseCell

@property (nonatomic, strong)MKContactTrackerTextCellModel *dataModel;

+ (MKContactTrackerTextCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
