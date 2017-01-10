//
//  DatePickerDialog.m
//  PriceCalender
//
//  Created by luwei on LWDATEPICKERDIALOG_MARGIN_V16/12/29.
//  Copyright © LWDATEPICKERDIALOG_MARGIN_V16年 HarrisHan. All rights reserved.
//

#import "LWCalendarHeader.h"

@interface LWDatePickerDialog ()<UIGestureRecognizerDelegate>

@property(nonatomic, strong) NSMutableArray *datePickerViewConstraints;

@end

@implementation LWDatePickerDialog

@synthesize
datePickerView  = _datePickerView,
currentDate     = _currentDate,
startDate       = _startDate,
endDate         = _endDate,
manager         = _manager,
dialogBuilder   = _dialogBuilder,
datePickerViewConstraints = _datePickerViewConstraints;

+(instancetype)initWithDate:(NSDate *)currentDate
                   Delegate:(id<LWDatePickerDelegate>)delegate{
    return [LWDatePickerDialog initWithDate:currentDate StartDate:currentDate Delegate:delegate Builder:[LWDatePickerBuilder defaultBuilder]];
}

+(instancetype)initWithDate:(NSDate *)currentDate
                   Delegate:(id<LWDatePickerDelegate>)delegate
                    Builder:(LWDatePickerBuilder *)builder{
    return [LWDatePickerDialog initWithDate:currentDate StartDate:currentDate Delegate:delegate Builder:builder];
}

+(instancetype)initWithDate:(NSDate *)currentDate
                  StartDate:(NSDate *)startDate
                   Delegate:(id<LWDatePickerDelegate>)delegate
                    Builder:(LWDatePickerBuilder *)builder{
    return [LWDatePickerDialog initWithDate:currentDate StartDate:startDate EndDate:startDate Delegate:delegate Builder:builder];
}

+(instancetype)initWithDate:(NSDate *)currentDate
                  StartDate:(NSDate *)startDate
                    EndDate:(NSDate *)endDate
                   Delegate:(id<LWDatePickerDelegate>)delegate
                    Builder:(LWDatePickerBuilder *)builder{
    LWDatePickerDialog *tmp = [[LWDatePickerDialog alloc] init];
    if (tmp) {
        //初始化代码
        tmp.dialogBuilder       = builder;
        tmp.controllerDelegate  = delegate;
        tmp.currentDate         = currentDate;
        tmp.startDate           = startDate;
        tmp.endDate             = endDate;
    }
    return tmp;
}

-(void)viewDidLoad{
    self.view.userInteractionEnabled = true;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
}

-(void)show{
    id<UIApplicationDelegate> delegate = [UIApplication sharedApplication].delegate;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0 ) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [delegate.window.rootViewController presentViewController:self animated:NO completion:^{
            [UIView animateWithDuration:self.dialogBuilder.LWDatePickerDialogAnimateDutation animations:^{
                self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                self.datePickerView.alpha = 1.0;
            }];
            
        }];
    }else{
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [delegate.window.rootViewController presentViewController:self animated:NO completion:^{
            [UIView animateWithDuration:self.dialogBuilder.LWDatePickerDialogAnimateDutation animations:^{
                self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                self.datePickerView.alpha = 1.0;
            }];
        }];
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
}

-(void)hide{
    [UIView animateWithDuration:self.dialogBuilder.LWDatePickerDialogAnimateDutation animations:^{
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
        self.datePickerView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}



#pragma mark Get And Set
-(LWDatePickerView *)datePickerView{
    if (_datePickerView == nil) {
        _datePickerView = [[LWDatePickerView alloc] init];
        _datePickerView.dialogDelegate = self;
        _datePickerView.alpha = 0.0;
        _datePickerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_datePickerView];
    }
    return _datePickerView;
}

-(LWCalendarManager *)manager{
    if (_manager == nil) {
        _manager = [[LWCalendarManager alloc] init];
        _manager.canSelectPastDays = true;
        _manager.selectionType = LWCalendarSelectionTypeRange;
    }
    return _manager;
}

-(void)setCurrentDate:(NSDate *)currentDate{
    if (currentDate == nil) {
        currentDate = [NSDate new];
    }
    _currentDate = currentDate;
    self.datePickerView.currentDate = _currentDate;
}

-(void)setStartDate:(NSDate *)startDate{
    if (startDate == nil) {
        startDate = [NSDate new];
    }
    _startDate = startDate;
    self.datePickerView.startDate = _startDate;
}

-(void)setEndDate:(NSDate *)endDate{
    if (endDate == nil) {
        endDate = [NSDate new];
    }
    _endDate = endDate;
    self.datePickerView.endDate = _endDate;
}

-(NSDate *)currentDate{
    if (_currentDate == nil) {
        _currentDate = [NSDate new];
    }
    return _currentDate;
}

-(NSDate *)startDate{
    _startDate = self.datePickerView.startDate;
    return _startDate;
}

-(NSDate *)endDate{
    _endDate = self.datePickerView.endDate;
    return _endDate;
}

-(void)setDialogBuilder:(LWDatePickerBuilder *)dialogBuilder{
    if (dialogBuilder == nil) {
        dialogBuilder = [LWDatePickerBuilder defaultBuilder];
    }
    if (_dialogBuilder != dialogBuilder) {
        _dialogBuilder = dialogBuilder;
        [self updateWithBuilder:dialogBuilder];
    }
}

-(LWDatePickerBuilder *)dialogBuilder{
    if (_dialogBuilder == nil) {
        _dialogBuilder = [LWDatePickerBuilder defaultBuilder];
    }
    return _dialogBuilder;
}

-(NSMutableArray *)datePickerViewConstraints{
    if (_datePickerViewConstraints == nil) {
        _datePickerViewConstraints = [NSMutableArray new];
    }
    return _datePickerViewConstraints;
}

#pragma mark UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.datePickerView]) {
        return NO;
    }
    return YES;
}

#pragma mark 处理屏幕旋转
-(BOOL)shouldAutorotate{
    //是否允许屏幕旋转
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    //viewController所支持的全部旋转方向
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    //viewController初始显示的方向
    return UIInterfaceOrientationPortrait;
}

#pragma mark 根据Build参数更新UI或者约束
-(void)updateWithBuilder:(LWDatePickerBuilder *)builder{
    [self.view removeConstraints:self.datePickerViewConstraints];
    [self.datePickerViewConstraints removeAllObjects];
    
    //添加约束
    NSLayoutConstraint *viewLeft = [NSLayoutConstraint constraintWithItem:self.datePickerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:builder.LWDatePickerDialogMarginH];
    NSLayoutConstraint *viewRight = [NSLayoutConstraint constraintWithItem:self.datePickerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-builder.LWDatePickerDialogMarginH];
    NSLayoutConstraint *viewTop = [NSLayoutConstraint constraintWithItem:self.datePickerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:builder.LWDatePickerDialogMarginV];
    NSLayoutConstraint *viewBottom = [NSLayoutConstraint constraintWithItem:self.datePickerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-builder.LWDatePickerDialogMarginV];
    [self.view addConstraint:viewLeft];
    [self.view addConstraint:viewRight];
    [self.view addConstraint:viewTop];
    [self.view addConstraint:viewBottom];
    [self.datePickerViewConstraints addObject:viewLeft];
    [self.datePickerViewConstraints addObject:viewRight];
    [self.datePickerViewConstraints addObject:viewTop];
    [self.datePickerViewConstraints addObject:viewBottom];
    
    self.datePickerView.dialogBuilder = builder;
}

@end
