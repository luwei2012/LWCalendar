//
//  ViewController.m
//  LWCalendar
//
//  Created by luwei on 2017/1/8.
//  Copyright © 2017年 luwei. All rights reserved.
//

#import "ViewController.h"
#import "LWDatePickerDialog.h"

@interface ViewController ()<LWDatePickerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(show)];
    [self.view addGestureRecognizer:recognizer];
}

- (void)didReceiveMemoryWarning {
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
