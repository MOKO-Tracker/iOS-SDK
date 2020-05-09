//
//  MKAdvTriggerCell.h
//  MKContactTracker
//
//  Created by aa on 2020/4/23.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKBaseCell.h"
#import "MKAdvertiserCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKAdvTriggerCell : MKBaseCell

@property (nonatomic, strong)NSDictionary *conditions;

@property (nonatomic, weak)id <MKAdvertiserCellDelegate>delegate;

+ (MKAdvTriggerCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
