//
//  ViewController.m
// 简书：http://www.jianshu.com/users/c1bb6aa0e422/latest_articles
//
//  Created by Harris on 16/4/27.
//  Copyright © 2016年 HarrisHan. All rights reserved.
//

#import "ViewController.h"
#import "CalenderView.h"
#import "DateViewController.h"
#import "ZYCalendarView.h"
#import "DatePickerDialog.h"

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
    //    DateViewController *vc = [[DateViewController alloc] init];
    //
    //    [vc setFinishBlock:^(NSUInteger start_year,NSUInteger start_month, NSUInteger start_day, NSUInteger end_year,NSUInteger end_month,NSUInteger end_day) {
    //        NSLog(@"开始日期:%ld-%ld-%ld;结束日期:%ld-%ld-%ld",start_year,start_month,start_day,end_year,end_month,end_day);
    //    }];
    //    [vc show];
    
    
//        UIView *weekTitlesView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
//        [self.view addSubview:weekTitlesView];
//        CGFloat weekW = self.view.frame.size.width/7;
//        NSArray *titles = @[@"日", @"一", @"二", @"三",
//                            @"四", @"五", @"六"];
//        for (int i = 0; i < 7; i++) {
//            UILabel *week = [[UILabel alloc] initWithFrame:CGRectMake(i*weekW, 20, weekW, 44)];
//            week.textAlignment = NSTextAlignmentCenter;
//            week.textColor = ZYHEXCOLOR(0x666666);
//    
//            [weekTitlesView addSubview:week];
//            week.text = titles[i];
//        }
//    
//    
//        ZYCalendarView *view = [[ZYCalendarView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
//    
//        // 不可以点击已经过去的日期
//        view.manager.canSelectPastDays = false;
//        // 可以选择时间段
//        view.manager.selectionType = ZYCalendarSelectionTypeRange;
//        // 设置当前日期
//        view.date = [NSDate date];
//    
//        view.dayViewBlock = ^(NSDate *dayDate) {
//            NSLog(@"%@", dayDate);
//        };
//        [self.view addSubview:view];
    
     [[DatePickerDialog initWithDate:[NSDate date] Delegate:self] show];
}

-(void)onDateSet:(DatePickerDialog *)dialog StartDate:(NSDate *)start EndDate:(NSDate *)end{
    NSLog(@"onDateSet");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
