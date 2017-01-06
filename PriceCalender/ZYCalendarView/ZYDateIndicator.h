//
//  DateIndicator.h
//  PriceCalender
//
//  Created by luwei on 2017/1/4.
//  Copyright © 2017年 HarrisHan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZYDatePickerView;

@interface ZYDateIndicator : UIView

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDate *date;
@property(nonatomic, weak) ZYDatePickerView *dateViewDelegate;

+(instancetype)initWithTitle:(NSString *)title Date:(NSDate *)date Delegate:(ZYDatePickerView *)delegate;

@end
