//
//  DateIndicator.h
//  PriceCalender
//
//  Created by luwei on 2017/1/4.
//  Copyright © 2017年 HarrisHan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatePickerView;

@interface DateIndicator : UIView

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *dateButton;
@property(nonatomic, strong) NSDate *date;
@property(nonatomic, weak) DatePickerView *dateViewDelegate;

+(instancetype)initWithTitle:(NSString *)title Date:(NSDate *)date Delegate:(DatePickerView *)delegate;

@end
