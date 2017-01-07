//
//  DatePickerView.m
//  PriceCalender
//
//  Created by luwei on 2017/1/4.
//  Copyright © 2017年 HarrisHan. All rights reserved.
//
#import "ZYCalendarHeader.h"


@interface ZYDatePickerView ()
@property(nonatomic, strong) UIView *contentView;//内容容器，DatePickerView自身作为阴影层
@property(nonatomic, strong) NSMutableArray *fromIndicatorConstraints;
@property(nonatomic, strong) NSMutableArray *toIndicatorConstraints;
@property(nonatomic, strong) NSMutableArray *calendarViewConstraints;
@end

@implementation ZYDatePickerView{
    UIInterfaceOrientation lastOrientation;
}

@synthesize cancelButton = _cancelButton, confirmButton = _confirmButton, calendarView = _calendarView, contentView = _contentView,
fromIndicator = _fromIndicator, toIndicator = _toIndicator,currentDate = _currentDate, startDate = _startDate, endDate = _endDate;

#pragma mark Override函数
-(instancetype)init{
    if (self = [super init]) {
        self.layer.shadowColor = SHADOW_COLOR;
        self.layer.shadowOffset = SHADOW_OFFSET;
        self.layer.shadowOpacity = SHADOW_OPACITY;
        self.layer.shadowRadius = SHADOW_RADIUS;
        self.fromIndicatorConstraints = [NSMutableArray new];
        self.toIndicatorConstraints = [NSMutableArray new];
        self.calendarViewConstraints = [NSMutableArray new];
        //初始化cancel和confirm按钮
        [self.confirmButton addTarget:self action:@selector(confirmOnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelButton addTarget:self action:@selector(cancelOnClick) forControlEvents:UIControlEventTouchUpInside];
        //初始化月、天选择器
        [self calendarView];
        //初始化顶部的年月显示器
        [self fromIndicator];
        [self toIndicator];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectDateChanged) name:ZYDAYVIEW_DATE_CHANGED object:nil];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    UIInterfaceOrientation interfaceOrientation=[[UIApplication sharedApplication] statusBarOrientation];
    if (lastOrientation == UIDeviceOrientationUnknown || lastOrientation != interfaceOrientation) {
        lastOrientation = interfaceOrientation;
        [self updateConstraintForToCalendarView];
        [self updateConstraintForToIndicator];
        [self updateConstraintForFromIndicator];
        [self updateConstraintsIfNeeded];
    }
    
}


#pragma mark 本地通知绑定的函数
-(void)selectDateChanged{
    self.fromIndicator.date = self.startDate;
    self.toIndicator.date = self.endDate;
}

#pragma mark 点击事件
-(void)cancelOnClick{
    [self.dialogDelegate hide];
}

-(void)confirmOnClick{
    if (self.dialogDelegate.controllerDelegate && [self.dialogDelegate.controllerDelegate respondsToSelector:@selector(onDateSet:StartDate:EndDate:)]) {
        [self.dialogDelegate.controllerDelegate onDateSet:self.dialogDelegate
                                                StartDate:self.startDate
                                                  EndDate:self.endDate];
    }
    
    [self.dialogDelegate hide];
}

-(void)fromIndicatorOnClick{
    //将Calendar滚动到from的位置
    if (self.startDate) {
        [self.calendarView scrollToDate:self.startDate];
    }
}

-(void)toIndicatorOnClick{
    //将Calendar滚动到to的位置
    if (self.endDate) {
        [self.calendarView scrollToDate:self.endDate];
    }
}

#pragma mark Get and Set
-(UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.layer.cornerRadius = CORNER_RADIUS;
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.backgroundColor = [UIColor whiteColor].CGColor;
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_contentView];
        //添加约束
        NSLayoutConstraint *viewLeft = [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewRight = [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewTop = [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewBottom = [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        [self addConstraint:viewLeft];
        [self addConstraint:viewRight];
        [self addConstraint:viewTop];
        [self addConstraint:viewBottom];
    }
    return _contentView;
}

-(UIButton *)cancelButton{
    if (_cancelButton == nil) {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setTitle:@"CANCEL" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:SelectedBgColor forState:UIControlStateNormal];
        _cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:BUTTON_FONT_SIZE];
        _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_cancelButton];
        //添加约束
        NSLayoutConstraint *viewWidth = [NSLayoutConstraint constraintWithItem:_cancelButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.confirmButton attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewRight = [NSLayoutConstraint constraintWithItem:_cancelButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.confirmButton attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-BUTTON_MARGIN_H];
        NSLayoutConstraint *viewTop = [NSLayoutConstraint constraintWithItem:_cancelButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.confirmButton attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewHeight = [NSLayoutConstraint constraintWithItem:_cancelButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.confirmButton attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0];
        [self.contentView addConstraint:viewWidth];
        [self.contentView addConstraint:viewRight];
        [self.contentView addConstraint:viewTop];
        [self.contentView addConstraint:viewHeight];
    }
    return _cancelButton;
}

-(UIButton *)confirmButton{
    if (_confirmButton == nil) {
        _confirmButton = [[UIButton alloc] init];
        [_confirmButton setTitle:@"OK" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:SelectedBgColor forState:UIControlStateNormal];
        _confirmButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:BUTTON_FONT_SIZE];
        _confirmButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_confirmButton];
        //添加约束
        NSLayoutConstraint *viewWidth = [NSLayoutConstraint constraintWithItem:_confirmButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:BUTTON_WIDTH constant:0.0];
        NSLayoutConstraint *viewRight = [NSLayoutConstraint constraintWithItem:_confirmButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewBottom = [NSLayoutConstraint constraintWithItem:_confirmButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewHeight = [NSLayoutConstraint constraintWithItem:_confirmButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:BUTTON_HEIGHT];
        [self.contentView addConstraint:viewWidth];
        [self.contentView addConstraint:viewRight];
        [self.contentView addConstraint:viewBottom];
        [self.confirmButton addConstraint:viewHeight];
    }
    return _confirmButton;
}


-(ZYDateIndicator *)fromIndicator{
    if (_fromIndicator == nil) {
        _fromIndicator = [ZYDateIndicator initWithTitle:@"FROM" Date:self.dialogDelegate.startDate Delegate:self];
        _fromIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        _fromIndicator.userInteractionEnabled = TRUE;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fromIndicatorOnClick)];
        [_fromIndicator addGestureRecognizer:recognizer];
        [self.contentView addSubview:_fromIndicator];
    }
    return _fromIndicator;
}


-(ZYDateIndicator *)toIndicator{
    if (_toIndicator == nil) {
        _toIndicator = [ZYDateIndicator initWithTitle:@"TO" Date:self.dialogDelegate.endDate Delegate:self];
        _toIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        _toIndicator.userInteractionEnabled = TRUE;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toIndicatorOnClick)];
        [_toIndicator addGestureRecognizer:recognizer];
        [self.contentView addSubview:_toIndicator];
    }
    return _toIndicator;
}

-(ZYCalendarView *)calendarView{
    if (_calendarView == nil) {
        _calendarView = [[ZYCalendarView alloc] init];
        _calendarView.dateViewDelegate = self;
        _calendarView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_calendarView];
    }
    return _calendarView;
}

-(void)setCurrentDate:(NSDate *)currentDate{
    _currentDate = currentDate;
    self.calendarView.currentDate = _currentDate;
}

-(void)setStartDate:(NSDate *)startDate{
    _startDate = startDate;
    self.calendarView.startDate = _startDate;
    self.fromIndicator.date = _startDate;
}

-(void)setEndDate:(NSDate *)endDate{
    _endDate = endDate;
    self.calendarView.endDate = _endDate;
    self.toIndicator.date = _endDate;
}

-(NSDate *)currentDate{
    return _currentDate;
}

-(NSDate *)startDate{
    _startDate = self.calendarView.startDate;
    return _startDate;
}

-(NSDate *)endDate{
    _endDate = self.calendarView.endDate;
    return _endDate;
}

#pragma mark 约束相关代码
//FromIndicator的约束
-(void)updateConstraintForFromIndicator{
    [self.contentView removeConstraints:self.fromIndicatorConstraints];
    [self.fromIndicatorConstraints removeAllObjects];
    UIInterfaceOrientation interfaceOrientation=[[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        NSLayoutConstraint *viewWidth = [NSLayoutConstraint constraintWithItem:_fromIndicator attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.toIndicator attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewLeft = [NSLayoutConstraint constraintWithItem:_fromIndicator attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewTop = [NSLayoutConstraint constraintWithItem:_fromIndicator attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewHeight = [NSLayoutConstraint constraintWithItem:_fromIndicator attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:DATE_TITLE_HEIGHT * 2.5];
        [self.contentView addConstraint:viewWidth];
        [self.contentView addConstraint:viewLeft];
        [self.contentView addConstraint:viewTop];
        [self.contentView addConstraint:viewHeight];
        [self.fromIndicatorConstraints addObject:viewLeft];
        [self.fromIndicatorConstraints addObject:viewWidth];
        [self.fromIndicatorConstraints addObject:viewTop];
        [self.fromIndicatorConstraints addObject:viewHeight];
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
        //翻转为横屏时
        NSLayoutConstraint *viewWidth = [NSLayoutConstraint constraintWithItem:_fromIndicator attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.toIndicator attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewLeft = [NSLayoutConstraint constraintWithItem:_fromIndicator attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewTop = [NSLayoutConstraint constraintWithItem:_fromIndicator attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewBottom = [NSLayoutConstraint constraintWithItem:_fromIndicator attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.confirmButton attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        [self.contentView addConstraint:viewWidth];
        [self.contentView addConstraint:viewLeft];
        [self.contentView addConstraint:viewTop];
        [self.contentView addConstraint:viewBottom];
        [self.fromIndicatorConstraints addObject:viewLeft];
        [self.fromIndicatorConstraints addObject:viewWidth];
        [self.fromIndicatorConstraints addObject:viewTop];
        [self.fromIndicatorConstraints addObject:viewBottom];
    }
}

//ToIndicator的约束
-(void)updateConstraintForToIndicator{
    [self.contentView removeConstraints:self.toIndicatorConstraints];
    [self.toIndicatorConstraints removeAllObjects];
    UIInterfaceOrientation interfaceOrientation=[[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        NSLayoutConstraint *viewRight = [NSLayoutConstraint constraintWithItem:_toIndicator attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewLeft = [NSLayoutConstraint constraintWithItem:_toIndicator attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.fromIndicator attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewTop = [NSLayoutConstraint constraintWithItem:_toIndicator attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewBottom = [NSLayoutConstraint constraintWithItem:_toIndicator attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.fromIndicator attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        [self.contentView addConstraint:viewRight];
        [self.contentView addConstraint:viewLeft];
        [self.contentView addConstraint:viewTop];
        [self.contentView addConstraint:viewBottom];
        [self.toIndicatorConstraints addObject:viewLeft];
        [self.toIndicatorConstraints addObject:viewRight];
        [self.toIndicatorConstraints addObject:viewTop];
        [self.toIndicatorConstraints addObject:viewBottom];
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
        //翻转为横屏时
        NSLayoutConstraint *viewRight = [NSLayoutConstraint constraintWithItem:_toIndicator attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.calendarView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewLeft = [NSLayoutConstraint constraintWithItem:_toIndicator attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.fromIndicator attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewTop = [NSLayoutConstraint constraintWithItem:_toIndicator attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewBottom = [NSLayoutConstraint constraintWithItem:_toIndicator attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.fromIndicator attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        [self.contentView addConstraint:viewRight];
        [self.contentView addConstraint:viewLeft];
        [self.contentView addConstraint:viewTop];
        [self.contentView addConstraint:viewBottom];
        [self.toIndicatorConstraints addObject:viewLeft];
        [self.toIndicatorConstraints addObject:viewRight];
        [self.toIndicatorConstraints addObject:viewTop];
        [self.toIndicatorConstraints addObject:viewBottom];
    }
}

//ZYCalendarView的约束
-(void)updateConstraintForToCalendarView{
    [self.contentView removeConstraints:self.calendarViewConstraints];
    [self.calendarViewConstraints removeAllObjects];
    UIInterfaceOrientation interfaceOrientation=[[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        NSLayoutConstraint *viewRight = [NSLayoutConstraint constraintWithItem:_calendarView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewLeft = [NSLayoutConstraint constraintWithItem:_calendarView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewTop = [NSLayoutConstraint constraintWithItem:_calendarView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.fromIndicator attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewBottom = [NSLayoutConstraint constraintWithItem:_calendarView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.confirmButton attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        [self.contentView addConstraint:viewRight];
        [self.contentView addConstraint:viewLeft];
        [self.contentView addConstraint:viewBottom];
        [self.contentView addConstraint:viewTop];
        [self.calendarViewConstraints addObject:viewLeft];
        [self.calendarViewConstraints addObject:viewRight];
        [self.calendarViewConstraints addObject:viewTop];
        [self.calendarViewConstraints addObject:viewBottom];
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
        //翻转为横屏时
        NSLayoutConstraint *viewRight = [NSLayoutConstraint constraintWithItem:_calendarView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewWidth = [NSLayoutConstraint constraintWithItem:_calendarView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0.0];
        NSLayoutConstraint *viewBottom = [NSLayoutConstraint constraintWithItem:_calendarView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.confirmButton attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewTop = [NSLayoutConstraint constraintWithItem:_calendarView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        [self.contentView addConstraint:viewRight];
        [self.contentView addConstraint:viewWidth];
        [self.contentView addConstraint:viewBottom];
        [self.contentView addConstraint:viewTop];
        [self.calendarViewConstraints addObject:viewWidth];
        [self.calendarViewConstraints addObject:viewRight];
        [self.calendarViewConstraints addObject:viewTop];
        [self.calendarViewConstraints addObject:viewBottom];
    }
}

@end
