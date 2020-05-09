//
//  MKAdvIntervalCell.h
//  MKContactTracker
//
//  Created by aa on 2020/4/23.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKBaseCell.h"
#import "MKAdvertiserCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKAdvIntervalCell : MKBaseCell

@property (nonatomic, copy)NSString *interval;

@property (nonatomic, weak)id <MKAdvertiserCellDelegate>delegate;

+ (MKAdvIntervalCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
