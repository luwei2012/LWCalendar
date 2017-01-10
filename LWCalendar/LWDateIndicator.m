//
//  DateIndicator.m
//  PriceCalender
//
//  Created by luwei on 2017/1/4.
//  Copyright © 2017年 HarrisHan. All rights reserved.
//

#import "LWCalendarHeader.h"

@interface LWDateIndicator ()
@property (nonatomic, strong) NSMutableArray *titleLabelConstraints;
@property (nonatomic, strong) NSMutableArray *dateLabelConstraints;
@end

@implementation LWDateIndicator
@synthesize
titleLabel      = _titleLabel,
dateLabel       = _dateLabel,
date            = _date,
dialogBuilder   = _dialogBuilder;

+(instancetype)initWithTitle:(NSString *)title Date:(NSDate *)date Delegate:(LWDatePickerView *)delegate{
    LWDateIndicator *tmp = [[LWDateIndicator alloc] init];
    if (tmp) {
        tmp.titleLabelConstraints = [NSMutableArray new];
        tmp.dateLabelConstraints = [NSMutableArray new];
        //初始化操作
        tmp.dateViewDelegate = delegate;
        tmp.titleLabel.text = title;
        tmp.date = date;
        [tmp updateWithBuilder:tmp.dialogBuilder];
    }
    return tmp;
}


#pragma mark Get and Set
-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

-(UILabel *)dateLabel{
    if (_dateLabel == nil) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_dateLabel];
        
        
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

-(void)setDialogBuilder:(LWDatePickerBuilder *)dialogBuilder{
    if (dialogBuilder && _dialogBuilder != dialogBuilder) {
        _dialogBuilder = dialogBuilder;
        [self updateWithBuilder:dialogBuilder];
    }
}

-(LWDatePickerBuilder *)dialogBuilder{
    if(_dialogBuilder == nil){
        if (self.dateViewDelegate) {
            _dialogBuilder = self.dateViewDelegate.dialogBuilder;
        }else{
            _dialogBuilder = [LWDatePickerBuilder defaultBuilder];
        }
    }
    return _dialogBuilder;
}

#pragma mark 根据Build参数更新UI或者约束
-(void)updateWithBuilder:(LWDatePickerBuilder *)builder{
    //title设置
    self.titleLabel.font = self.dialogBuilder.LWDateIndicatorTitleFont;
    self.titleLabel.textColor = self.dialogBuilder.LWDatePickerViewDefaultTextColor;
    self.titleLabel.backgroundColor = self.dialogBuilder.LWDatePickerViewDefaultColor;
    //date设置
    self.dateLabel.font = self.dialogBuilder.LWDateIndicatorDateFont;
    self.dateLabel.textColor= self.dialogBuilder.LWDatePickerViewSelectedTextColor;
    self.dateLabel.backgroundColor = self.dialogBuilder.LWDatePickerViewSelectedColor;
    //约束更新
    [self updateConstraintForTitleLabel];
    [self updateConstraintForDateLabel];
}

#pragma mark 约束相关
-(void)updateConstraintForTitleLabel{
    [self removeConstraints:self.titleLabelConstraints];
    [self.titleLabelConstraints removeAllObjects];
    //添加约束
    NSLayoutConstraint *viewLeft = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    NSLayoutConstraint *viewRight = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
    NSLayoutConstraint *viewTop = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    NSLayoutConstraint *viewHeight = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.dialogBuilder.LWDateIndicatorTitleHeight];
    [self addConstraint:viewLeft];
    [self addConstraint:viewRight];
    [self addConstraint:viewTop];
    [self addConstraint:viewHeight];
    [self.titleLabelConstraints addObject:viewLeft];
    [self.titleLabelConstraints addObject:viewRight];
    [self.titleLabelConstraints addObject:viewTop];
    [self.titleLabelConstraints addObject:viewHeight];
}

-(void)updateConstraintForDateLabel{
    [self removeConstraints:self.dateLabelConstraints];
    [self.dateLabelConstraints removeAllObjects];
    //添加约束
    NSLayoutConstraint *viewLeft = [NSLayoutConstraint constraintWithItem:self.dateLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    NSLayoutConstraint *viewRight = [NSLayoutConstraint constraintWithItem:self.dateLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
    NSLayoutConstraint *viewTop = [NSLayoutConstraint constraintWithItem:self.dateLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    NSLayoutConstraint *viewBottom = [NSLayoutConstraint constraintWithItem:self.dateLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    [self addConstraint:viewLeft];
    [self addConstraint:viewRight];
    [self addConstraint:viewTop];
    [self addConstraint:viewBottom];
    [self.dateLabelConstraints addObject:viewLeft];
    [self.dateLabelConstraints addObject:viewRight];
    [self.dateLabelConstraints addObject:viewTop];
    [self.dateLabelConstraints addObject:viewBottom];
}

@end
