//
//  ViewController.m
// 简书：http://www.jianshu.com/users/c1bb6aa0e422/latest_articles
//
//  Created by Harris on 16/4/27.
//  Copyright © 2016年 HarrisHan. All rights reserved.
//

#import "ViewController.h"
#import "ZYDatePickerDialog.h"

@interface ViewController ()<DatePickerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(show)];
    [self.view addGestureRecognizer:recognizer];
}

-(void)show{
     [[ZYDatePickerDialog initWithDate:[NSDate date] Delegate:self] show];
}

-(void)onDateSet:(ZYDatePickerDialog *)dialog StartDate:(NSDate *)start EndDate:(NSDate *)end{
    NSLog(@"onDateSet");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
