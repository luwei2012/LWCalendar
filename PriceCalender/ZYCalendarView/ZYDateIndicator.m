//
//  DateIndicator.m
//  PriceCalender
//
//  Created by luwei on 2017/1/4.
//  Copyright © 2017年 HarrisHan. All rights reserved.
//

#import "ZYCalendarHeader.h"

@implementation ZYDateIndicator
@synthesize titleLabel = _titleLabel, dateLabel = _dateLabel, date = _date;

+(instancetype)initWithTitle:(NSString *)title Date:(NSDate *)date Delegate:(ZYDatePickerView *)delegate{
    ZYDateIndicator *tmp = [[ZYDateIndicator alloc] init];
    if (tmp) {
        //初始化操作
        tmp.dateViewDelegate = delegate;
        tmp.titleLabel.text = title;
        tmp.date = date;
    }
    return tmp;
}


#pragma mark Get and Set
-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:DATE_TITLE_FONT_SIZE];
        _titleLabel.textColor= [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_titleLabel];
        //添加约束
        NSLayoutConstraint *viewLeft = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewRight = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewTop = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewHeight = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:DATE_TITLE_HEIGHT];
        [self addConstraint:viewLeft];
        [self addConstraint:viewRight];
        [self addConstraint:viewTop];
        [_titleLabel addConstraint:viewHeight];
        
    }
    return _titleLabel;
}

-(UILabel *)dateLabel{
    if (_dateLabel == nil) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.font = [UIFont boldSystemFontOfSize:DATE_SHOW_FONT_SIZE];
        _dateLabel.textColor= [UIColor whiteColor];
        _dateLabel.backgroundColor = SelectedBgColor;
        _dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_dateLabel];
        //添加约束
        NSLayoutConstraint *viewLeft = [NSLayoutConstraint constraintWithItem:_dateLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewRight = [NSLayoutConstraint constraintWithItem:_dateLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewTop = [NSLayoutConstraint constraintWithItem:_dateLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewBottom = [NSLayoutConstraint constraintWithItem:_dateLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        [self addConstraint:viewLeft];
        [self addConstraint:viewRight];
        [self addConstraint:viewTop];
        [self addConstraint:viewBottom];
        
    }
    return _dateLabel;
}

-(void)setDate:(NSDate *)date{
    //更新date
    _date = date;
    if (date) {
        // 某月
        NSString *dateStr = [self.dateViewDelegate.dialogDelegate.manager.dateFormatter stringFromDate:date];
        self.dateLabel.text = dateStr;
    }else{
        self.dateLabel.text = @"";
    }
}

@end
