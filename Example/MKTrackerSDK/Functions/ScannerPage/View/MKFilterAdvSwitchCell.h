//
//  MKFilterAdvSwitchCell.h
//  MKContactTracker
//
//  Created by aa on 2020/4/24.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MKFilterAdvSwitchCellDelegate <NSObject>

- (void)filterAdvSwitchStatusChanged:(BOOL)isOn;

@end

@interface MKFilterAdvSwitchCell : MKBaseCell

@property (nonatomic, weak)id <MKFilterAdvSwitchCellDelegate>delegate;

@property (nonatomic, assign)BOOL isOn;

+ (MKFilterAdvSwitchCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
