//
//  DatePickerDialog.h
//  PriceCalender
//
//  Created by luwei on 2016/12/29.
//  Copyright © 2016年 HarrisHan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LWDatePickerDialog,LWCalendarManager, LWDatePickerView, LWDatePickerBuilder;

/**
 日期选择器的回调
 */
@protocol LWDatePickerDelegate <NSObject>

- (void)onDateSet:(LWDatePickerDialog*)dialog
        StartDate:(NSDate *)start
          EndDate:(NSDate *)end;

@end

@interface LWDatePickerDialog :  UIViewController
@property(nonatomic, strong) LWDatePickerBuilder *dialogBuilder;  //日期选择器的样式配置
@property(nonatomic, strong) LWDatePickerView *datePickerView;   //日期选择器的容器
@property(nonatomic, strong) LWCalendarManager *manager;        //日期选择器的配置参数
@property(nonatomic, strong) NSDate *currentDate;               //今日日期 特殊显示
@property(nonatomic, strong) NSDate *startDate;                 //选中的开始日期，默认为今日日期
@property(nonatomic, strong) NSDate *endDate;                   //选中的结束日期，默认为开始日期
@property(nonatomic, weak) id<LWDatePickerDelegate> controllerDelegate; //日期选择器的回调

//提供了三个创建函数 今日日期和回调是必填参数 但是都是可空的 今日日期为空时将会使用当前时间作为今日日期
+ (instancetype)initWithDate:(NSDate *)currentDate
                   StartDate:(NSDate *)startDate
                     EndDate:(NSDate *)endDate
                    Delegate:(id<LWDatePickerDelegate>)delegate
                     Builder:(LWDatePickerBuilder *)builder;

+ (instancetype)initWithDate:(NSDate *)currentDate
                   StartDate:(NSDate *)startDate
                    Delegate:(id<LWDatePickerDelegate>)delegate
                     Builder:(LWDatePickerBuilder *)builder;

+ (instancetype)initWithDate:(NSDate *)currentDate
                    Delegate:(id<LWDatePickerDelegate>)delegate
                     Builder:(LWDatePickerBuilder *)builder;

+ (instancetype)initWithDate:(NSDate *)currentDate
                    Delegate:(id<LWDatePickerDelegate>)delegate;

//显示日期选择器
- (void)show;
//隐藏日期选择器
- (void)hide; 


@end
