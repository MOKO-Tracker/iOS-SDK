//
//  MKTriggerSenSlider.m
//  MKContactTracker
//
//  Created by aa on 2020/5/5.
//  Copyright © 2020 MK. All rights reserved.
//

#import "MKTriggerSenSlider.h"

@implementation MKTriggerSenSlider

- (instancetype)init{
    if (self = [super init]) {
        [self setThumbImage:[LOADIMAGE(@"sensitivityThumbIcon", @"png") resizableImageWithCapInsets:UIEdgeInsetsZero]
                   forState:UIControlStateNormal];
        [self setThumbImage:[LOADIMAGE(@"sensitivityThumbIcon", @"png") resizableImageWithCapInsets:UIEdgeInsetsZero]
                   forState:UIControlStateHighlighted];
        [self setMinimumTrackImage:[LOADIMAGE(@"sensitivityMinTrackIcon", @"png") resizableImageWithCapInsets:UIEdgeInsetsZero]
                          forState:UIControlStateNormal];
        [self setMaximumTrackImage:[LOADIMAGE(@"sensitivityMaxTrackIcon", @"png") resizableImageWithCapInsets:UIEdgeInsetsZero] forState:UIControlStateNormal];
    }
    return self;
}

@end
