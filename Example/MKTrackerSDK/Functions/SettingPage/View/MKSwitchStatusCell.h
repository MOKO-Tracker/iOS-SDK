//
//  MKSwitchStatusCell.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/24.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MKSwitchStatusCellDelegate <NSObject>

- (void)needChangedCellSwitchStatus:(BOOL)isOn row:(NSInteger)row;

@end

@class MKSwitchStatusCellModel;
@interface MKSwitchStatusCell : MKBaseCell

+ (MKSwitchStatusCell *)initCellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak)id <MKSwitchStatusCellDelegate>delegate;

@property (nonatomic, strong)MKSwitchStatusCellModel *dataModel;

@end

NS_ASSUME_NONNULL_END
