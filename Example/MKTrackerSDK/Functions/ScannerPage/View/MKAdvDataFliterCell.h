//
//  MKAdvDataFliterCell.h
//  MKContactTracker
//
//  Created by aa on 2020/4/24.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MKAdvDataFliterCellDelegate <NSObject>

- (void)advDataFliterCellSwitchStatusChanged:(BOOL)isOn index:(NSInteger)index;

- (void)advertiserFilterContent:(NSString *)newValue index:(NSInteger)index;

@end

@class MKAdvDataFliterCellModel;
@interface MKAdvDataFliterCell : MKBaseCell

@property (nonatomic, weak)id <MKAdvDataFliterCellDelegate>delegate;

@property (nonatomic, strong)MKAdvDataFliterCellModel *dataModel;

+ (MKAdvDataFliterCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
