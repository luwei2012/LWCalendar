//
//  DateIndicator.h
//  PriceCalender
//
//  Created by luwei on 2017/1/4.
//  Copyright © 2017年 HarrisHan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LWDatePickerView;

@interface LWDateIndicator : UIView

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDate *date;
@property(nonatomic, weak) LWDatePickerView *dateViewDelegate;

+(instancetype)initWithTitle:(NSString *)title Date:(NSDate *)date Delegate:(LWDatePickerView *)delegate;

@end
