//
//  DateIndicator.m
//  PriceCalender
//
//  Created by luwei on 2017/1/4.
//  Copyright © 2017年 HarrisHan. All rights reserved.
//

#import "ZYCalendarHeader.h"

#define TITLE_HEIGHT (60)

@implementation DateIndicator
@synthesize titleLabel = _titleLabel, dateButton = _dateButton, date = _date;

+(instancetype)initWithTitle:(NSString *)title Date:(NSDate *)date Delegate:(DatePickerView *)delegate{
    DateIndicator *tmp = [[DateIndicator alloc] init];
    if (tmp) {
        //初始化操作
        tmp.dateViewDelegate = delegate;
        tmp.titleLabel.text = title;
        tmp.date = date;
        // 某月
        NSString *dateStr = [tmp.dateViewDelegate.dialogDelegate.manager.dateFormatter stringFromDate:date];
        tmp.dateButton.titleLabel.text = dateStr;
    }
    return tmp;
}


#pragma mark Get and Set
-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        _titleLabel.textColor= [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_titleLabel];
        //添加约束
        NSLayoutConstraint *viewLeft = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewRight = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewTop = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewHeight = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:TITLE_HEIGHT];
        [self addConstraint:viewLeft];
        [self addConstraint:viewRight];
        [self addConstraint:viewTop];
        [_titleLabel addConstraint:viewHeight];

    }
    return _titleLabel;
}

-(UIButton *)dateButton{
    if (_dateButton == nil) {
        _dateButton = [[UIButton alloc] init];
        _dateButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _dateButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        _dateButton.titleLabel.textColor= [UIColor whiteColor];
        _dateButton.backgroundColor = SelectedBgColor;
        _dateButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_dateButton];
        //添加约束
        NSLayoutConstraint *viewLeft = [NSLayoutConstraint constraintWithItem:_dateButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewRight = [NSLayoutConstraint constraintWithItem:_dateButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewTop = [NSLayoutConstraint constraintWithItem:_dateButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewBottom = [NSLayoutConstraint constraintWithItem:_dateButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        [self addConstraint:viewLeft];
        [self addConstraint:viewRight];
        [self addConstraint:viewTop];
        [self addConstraint:viewBottom];
        
    }
    return _dateButton;
}

-(void)setDate:(NSDate *)date{
    if (_date && date && ![self.dateViewDelegate.dialogDelegate.manager.helper date:date isTheSameDayThan:_date]) {
        //更新date
        _date = date;
        // 某月
        NSString *dateStr = [self.dateViewDelegate.dialogDelegate.manager.dateFormatter stringFromDate:date];
        self.dateButton.titleLabel.text = dateStr;
    }
}

@end
