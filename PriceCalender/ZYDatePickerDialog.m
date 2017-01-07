//
//  DatePickerDialog.m
//  PriceCalender
//
//  Created by luwei on DATEPICKER_MARGIN_V16/12/29.
//  Copyright © DATEPICKER_MARGIN_V16年 HarrisHan. All rights reserved.
//

#import "ZYCalendarHeader.h"
#import "AppDelegate.h"


static ZYDatePickerDialog *_instance;

@interface ZYDatePickerDialog ()<UIGestureRecognizerDelegate>

@end

@implementation ZYDatePickerDialog

@synthesize dateContainer = _dateContainer,currentDate = _currentDate ,startDate = _startDate, endDate = _endDate, manager = _manager;

+(instancetype)initWithDate:(NSDate *)currentDate Delegate:(id<DatePickerDelegate>)delegate{
    return [ZYDatePickerDialog initWithDate:currentDate StartDate:currentDate Delegate:delegate];
}

+(instancetype)initWithDate:(NSDate *)currentDate StartDate:(NSDate *)startDate Delegate:(id<DatePickerDelegate>)delegate{
    return [ZYDatePickerDialog initWithDate:currentDate StartDate:startDate EndDate:startDate Delegate:delegate];
}

+(instancetype)initWithDate:(NSDate *)currentDate StartDate:(NSDate *)startDate EndDate:(NSDate *)endDate Delegate:(id<DatePickerDelegate>)delegate{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_instance) {
            _instance = [[self alloc] init];
        }
    });
    //初始化代码
    _instance.controllerDelegate = delegate;
    _instance.currentDate = currentDate;
    _instance.startDate = startDate;
    _instance.endDate = endDate;
    return _instance;
}

-(void)viewDidLoad{
    self.view.userInteractionEnabled = true;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
}
 

-(void)show{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0 ) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [delegate.window.rootViewController presentViewController:self animated:NO completion:^{
            [UIView animateWithDuration:ANIMATE_DUTATION animations:^{
                self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                self.dateContainer.alpha = 1.0;
            }];
            
        }];
    }else{
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [delegate.window.rootViewController presentViewController:self animated:NO completion:^{
            [UIView animateWithDuration:ANIMATE_DUTATION animations:^{
                self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                self.dateContainer.alpha = 1.0;
            }];
        }];
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
}

-(void)hide{
    [UIView animateWithDuration:ANIMATE_DUTATION animations:^{
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
        self.dateContainer.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}



#pragma mark Get And Set
-(ZYDatePickerView *)dateContainer{
    if (_dateContainer == nil) {
        _dateContainer = [[ZYDatePickerView alloc] init];
        _dateContainer.dialogDelegate = self;
        _dateContainer.alpha = 0.0;
        _dateContainer.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_dateContainer];
        //添加约束
        NSLayoutConstraint *viewLeft = [NSLayoutConstraint constraintWithItem:_dateContainer attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:DATEPICKER_MARGIN_H];
        NSLayoutConstraint *viewRight = [NSLayoutConstraint constraintWithItem:_dateContainer attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-DATEPICKER_MARGIN_H];
        NSLayoutConstraint *viewTop = [NSLayoutConstraint constraintWithItem:_dateContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:DATEPICKER_MARGIN_V];
        NSLayoutConstraint *viewBottom = [NSLayoutConstraint constraintWithItem:_dateContainer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-DATEPICKER_MARGIN_V];
        [self.view addConstraint:viewLeft];
        [self.view addConstraint:viewRight];
        [self.view addConstraint:viewTop];
        [self.view addConstraint:viewBottom];
    }
    return _dateContainer;
}

-(ZYCalendarManager *)manager{
    if (_manager == nil) {
        _manager = [[ZYCalendarManager alloc] init];
        _manager.canSelectPastDays = true;
        _manager.selectionType = ZYCalendarSelectionTypeRange; 
    }
    return _manager;
}

-(void)setCurrentDate:(NSDate *)currentDate{
    _currentDate = currentDate;
    self.dateContainer.currentDate = _currentDate;
}

-(void)setStartDate:(NSDate *)startDate{
    _startDate = startDate;
    self.dateContainer.startDate = _startDate;
}

-(void)setEndDate:(NSDate *)endDate{
    _endDate = endDate;
    self.dateContainer.endDate = _endDate;
}

-(NSDate *)currentDate{
    return _currentDate;
}

-(NSDate *)startDate{
    _startDate = self.dateContainer.startDate;
    return _startDate;
}

-(NSDate *)endDate{
    _endDate = self.dateContainer.endDate;
    return _endDate;
}

#pragma mark UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.dateContainer]) {
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



@end
