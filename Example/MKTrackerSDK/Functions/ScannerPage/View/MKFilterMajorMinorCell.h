//
//  MKFilterMajorMinorCell.h
//  MKContactTracker
//
//  Created by aa on 2020/7/1.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MKFilterMajorMinorCellDelegate <NSObject>

- (void)majorMinorFliterSwitchStatusChanged:(BOOL)isOn index:(NSInteger)index;

- (void)filterMaxValueContentChanged:(NSString *)newValue index:(NSInteger)index;

- (void)filterMinValueContentChanged:(NSString *)newValue index:(NSInteger)index;

@end

@class MKFilterMajorMinorCellModel;
@interface MKFilterMajorMinorCell : MKBaseCell

@property (nonatomic, strong)MKFilterMajorMinorCellModel *dataModel;

@property (nonatomic, weak)id <MKFilterMajorMinorCellDelegate>delegate;

+ (MKFilterMajorMinorCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
