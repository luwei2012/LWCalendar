//
//  LWViewController.m
//  LWCalendar
//
//  Created by 1071932819@qq.com on 01/08/2017.
//  Copyright (c) 2017 1071932819@qq.com. All rights reserved.
//

#import "LWViewController.h"


@interface LWViewController ()<LWDatePickerDelegate>

@end

@implementation LWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(show)];
    [self.view addGestureRecognizer:recognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)show{
    [[LWDatePickerDialog initWithDate:[NSDate date] Delegate:self] show];
}

-(void)onDateSet:(LWDatePickerDialog *)dialog StartDate:(NSDate *)start EndDate:(NSDate *)end{
    NSLog(@"onDateSet");
}

@end
