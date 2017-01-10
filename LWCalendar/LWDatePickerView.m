//
//  DatePickerView.m
//  PriceCalender
//
//  Created by luwei on 2017/1/4.
//  Copyright © 2017年 HarrisHan. All rights reserved.
//
#import "LWCalendarHeader.h"


@interface LWDatePickerView ()
@property(nonatomic, strong) UIView *contentView;//内容容器，DatePickerView自身作为阴影层
@property(nonatomic, strong) NSMutableArray *fromIndicatorConstraints;
@property(nonatomic, strong) NSMutableArray *toIndicatorConstraints;
@property(nonatomic, strong) NSMutableArray *calendarViewConstraints;
@property(nonatomic, strong) NSMutableArray *confirmButtonConstraints;
@property(nonatomic, strong) NSMutableArray *cancelButtonConstraints;
@end

@implementation LWDatePickerView{
    UIInterfaceOrientation lastOrientation;
}

@synthesize
cancelButton    = _cancelButton,
confirmButton   = _confirmButton,
calendarView    = _calendarView,
contentView     = _contentView,
fromIndicator   = _fromIndicator,
toIndicator     = _toIndicator,
currentDate     = _currentDate,
startDate       = _startDate,
endDate         = _endDate,
dialogBuilder   = _dialogBuilder,
dialogDelegate  = _dialogDelegate;

#pragma mark Override函数
-(instancetype)init{
    if (self = [super init]) {
        self.fromIndicatorConstraints = [NSMutableArray new];
        self.toIndicatorConstraints = [NSMutableArray new];
        self.calendarViewConstraints = [NSMutableArray new];
        self.confirmButtonConstraints = [NSMutableArray new];
        self.cancelButtonConstraints = [NSMutableArray new];
        //初始化cancel和confirm按钮
        [self.confirmButton addTarget:self action:@selector(confirmOnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelButton addTarget:self action:@selector(cancelOnClick) forControlEvents:UIControlEventTouchUpInside];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectDateChanged) name:LWDAYVIEW_DATE_CHANGED object:nil];
        [self updateWithBuilder:self.dialogBuilder];
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
        //屏幕旋转时只需要更新部分约束
        [self updateConstraintForToCalendarView];
        [self updateConstraintForToIndicator];
        [self updateConstraintForFromIndicator];
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
        _cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_cancelButton];
    }
    return _cancelButton;
}

-(UIButton *)confirmButton{
    if (_confirmButton == nil) {
        _confirmButton = [[UIButton alloc] init];
        [_confirmButton setTitle:@"OK" forState:UIControlStateNormal];
        _confirmButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _confirmButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_confirmButton];
    }
    return _confirmButton;
}


-(LWDateIndicator *)fromIndicator{
    if (_fromIndicator == nil) {
        _fromIndicator = [LWDateIndicator initWithTitle:@"FROM" Date:self.dialogDelegate.startDate Delegate:self];
        _fromIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        _fromIndicator.userInteractionEnabled = TRUE;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fromIndicatorOnClick)];
        [_fromIndicator addGestureRecognizer:recognizer];
        [self.contentView addSubview:_fromIndicator];
    }
    return _fromIndicator;
}


-(LWDateIndicator *)toIndicator{
    if (_toIndicator == nil) {
        _toIndicator = [LWDateIndicator initWithTitle:@"TO" Date:self.dialogDelegate.endDate Delegate:self];
        _toIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        _toIndicator.userInteractionEnabled = TRUE;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toIndicatorOnClick)];
        [_toIndicator addGestureRecognizer:recognizer];
        [self.contentView addSubview:_toIndicator];
    }
    return _toIndicator;
}

-(LWCalendarView *)calendarView{
    if (_calendarView == nil) {
        _calendarView = [[LWCalendarView alloc] init];
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
 
-(LWDatePickerBuilder *)dialogBuilder{
    if(_dialogBuilder == nil){
        if (self.dialogDelegate) {
            _dialogBuilder = self.dialogDelegate.dialogBuilder;
        }else{
            _dialogBuilder = [LWDatePickerBuilder defaultBuilder];
        }
    }
    return _dialogBuilder;
}

-(void)setDialogBuilder:(LWDatePickerBuilder *)dialogBuilder{
    if (dialogBuilder && _dialogBuilder != dialogBuilder) {
        _dialogBuilder = dialogBuilder;
        [self updateWithBuilder:dialogBuilder];
    }
}

#pragma mark 约束相关代码
//FromIndicator的约束
-(void)updateConstraintForFromIndicator{
    [self.contentView removeConstraints:self.fromIndicatorConstraints];
    [self.fromIndicatorConstraints removeAllObjects];
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        NSLayoutConstraint *viewWidth = [NSLayoutConstraint constraintWithItem:self.fromIndicator attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.toIndicator attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewLeft = [NSLayoutConstraint constraintWithItem:self.fromIndicator attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewTop = [NSLayoutConstraint constraintWithItem:self.fromIndicator attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewHeight = [NSLayoutConstraint constraintWithItem:self.fromIndicator attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.dialogBuilder.LWDateIndicatorTitleHeight * 2.5];
        [self.contentView addConstraint:viewWidth];
        [self.contentView addConstraint:viewLeft];
        [self.contentView addConstraint:viewTop];
        [self.contentView addConstraint:viewHeight];
        [self.fromIndicatorConstraints addObject:viewLeft];
        [self.fromIndicatorConstraints addObject:viewWidth];
        [self.fromIndicatorConstraints addObject:viewTop];
        [self.fromIndicatorConstraints addObject:viewHeight];
    }else if (interfaceOrientation == UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
        //翻转为横屏时
        NSLayoutConstraint *viewWidth = [NSLayoutConstraint constraintWithItem:self.fromIndicator attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.toIndicator attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewLeft = [NSLayoutConstraint constraintWithItem:self.fromIndicator attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewTop = [NSLayoutConstraint constraintWithItem:self.fromIndicator attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewBottom = [NSLayoutConstraint constraintWithItem:self.fromIndicator attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.confirmButton attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
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
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        NSLayoutConstraint *viewRight = [NSLayoutConstraint constraintWithItem:self.toIndicator attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewLeft = [NSLayoutConstraint constraintWithItem:self.toIndicator attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.fromIndicator attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewTop = [NSLayoutConstraint constraintWithItem:self.toIndicator attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewBottom = [NSLayoutConstraint constraintWithItem:self.toIndicator attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.fromIndicator attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        [self.contentView addConstraint:viewRight];
        [self.contentView addConstraint:viewLeft];
        [self.contentView addConstraint:viewTop];
        [self.contentView addConstraint:viewBottom];
        [self.toIndicatorConstraints addObject:viewLeft];
        [self.toIndicatorConstraints addObject:viewRight];
        [self.toIndicatorConstraints addObject:viewTop];
        [self.toIndicatorConstraints addObject:viewBottom];
    }else if (interfaceOrientation == UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
        //翻转为横屏时
        NSLayoutConstraint *viewRight = [NSLayoutConstraint constraintWithItem:self.toIndicator attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.calendarView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewLeft = [NSLayoutConstraint constraintWithItem:self.toIndicator attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.fromIndicator attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewTop = [NSLayoutConstraint constraintWithItem:self.toIndicator attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewBottom = [NSLayoutConstraint constraintWithItem:self.toIndicator attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.fromIndicator attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
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

//LWCalendarView的约束
-(void)updateConstraintForToCalendarView{
    [self.contentView removeConstraints:self.calendarViewConstraints];
    [self.calendarViewConstraints removeAllObjects];
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        NSLayoutConstraint *viewRight = [NSLayoutConstraint constraintWithItem:self.calendarView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewLeft = [NSLayoutConstraint constraintWithItem:self.calendarView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewTop = [NSLayoutConstraint constraintWithItem:self.calendarView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.fromIndicator attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewBottom = [NSLayoutConstraint constraintWithItem:self.calendarView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.confirmButton attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        [self.contentView addConstraint:viewRight];
        [self.contentView addConstraint:viewLeft];
        [self.contentView addConstraint:viewBottom];
        [self.contentView addConstraint:viewTop];
        [self.calendarViewConstraints addObject:viewLeft];
        [self.calendarViewConstraints addObject:viewRight];
        [self.calendarViewConstraints addObject:viewTop];
        [self.calendarViewConstraints addObject:viewBottom];
    }else if (interfaceOrientation == UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
        //翻转为横屏时
        NSLayoutConstraint *viewRight = [NSLayoutConstraint constraintWithItem:self.calendarView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewWidth = [NSLayoutConstraint constraintWithItem:self.calendarView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0.0];
        NSLayoutConstraint *viewBottom = [NSLayoutConstraint constraintWithItem:self.calendarView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.confirmButton attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        NSLayoutConstraint *viewTop = [NSLayoutConstraint constraintWithItem:self.calendarView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
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


-(void)updateConstraintForConfirmButton{
    [self.contentView removeConstraints:self.confirmButtonConstraints];
    [self.confirmButtonConstraints removeAllObjects];
    //添加约束
    NSLayoutConstraint *viewWidth = [NSLayoutConstraint constraintWithItem:self.confirmButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:self.dialogBuilder.LWDatePickerViewButtonWidth constant:0.0];
    NSLayoutConstraint *viewRight = [NSLayoutConstraint constraintWithItem:self.confirmButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
    NSLayoutConstraint *viewBottom = [NSLayoutConstraint constraintWithItem:self.confirmButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    NSLayoutConstraint *viewHeight = [NSLayoutConstraint constraintWithItem:self.confirmButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.dialogBuilder.LWDatePickerViewButtonHeight];
    [self.contentView addConstraint:viewWidth];
    [self.contentView addConstraint:viewRight];
    [self.contentView addConstraint:viewBottom];
    [self.confirmButton addConstraint:viewHeight];
    [self.confirmButtonConstraints addObject:viewWidth];
    [self.confirmButtonConstraints addObject:viewRight];
    [self.confirmButtonConstraints addObject:viewBottom];
    [self.confirmButtonConstraints addObject:viewHeight];
}

-(void)updateConstraintForCancelButton{
    [self.contentView removeConstraints:self.cancelButtonConstraints];
    [self.cancelButtonConstraints removeAllObjects];
    //添加约束
    NSLayoutConstraint *viewWidth = [NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.confirmButton attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    NSLayoutConstraint *viewRight = [NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.confirmButton attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-self.dialogBuilder.LWDatePickerViewButtonMarginH];
    NSLayoutConstraint *viewTop = [NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.confirmButton attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    NSLayoutConstraint *viewHeight = [NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.confirmButton attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0];
    [self.contentView addConstraint:viewWidth];
    [self.contentView addConstraint:viewRight];
    [self.contentView addConstraint:viewTop];
    [self.contentView addConstraint:viewHeight];
    [self.cancelButtonConstraints addObject:viewWidth];
    [self.cancelButtonConstraints addObject:viewRight];
    [self.cancelButtonConstraints addObject:viewTop];
    [self.cancelButtonConstraints addObject:viewHeight];
}

#pragma mark 根据Build参数更新UI或者约束
-(void)updateWithBuilder:(LWDatePickerBuilder *)builder{
    //阴影配置
    self.layer.shadowColor = builder.LWDatePickerViewShadowColor.CGColor;
    self.layer.shadowOffset = builder.LWDatePickerViewShadowOffset;
    self.layer.shadowOpacity = builder.LWDatePickerViewShadowOpacity;
    self.layer.shadowRadius = builder.LWDatePickerViewShadowRadius;
    //contentView设置
    self.contentView.layer.cornerRadius = builder.LWDatePickerDialogCorner;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.backgroundColor = builder.LWDatePickerViewDefaultColor.CGColor;
    //cancelButton设置
    [self.cancelButton setTitleColor:builder.LWDatePickerViewSelectedColor forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = builder.LWDatePickerViewButtonFont;
    //confirmButton设置
    [self.confirmButton setTitleColor:builder.LWDatePickerViewSelectedColor forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = builder.LWDatePickerViewButtonFont;
    //fromIndicator设置
    self.fromIndicator.dialogBuilder = builder;
    //toIndicator设置
    self.toIndicator.dialogBuilder = builder;
    //更新约束
    [self updateConstraintForConfirmButton];
    [self updateConstraintForCancelButton];
    [self updateConstraintForToCalendarView];
    [self updateConstraintForToIndicator];
    [self updateConstraintForFromIndicator];
    //calendar设置
    self.calendarView.dialogBuilder = builder;
}

@end
