//
//  LWCalendarManager.h
//  Example
//
//  Created by Daniel on 2016/10/30.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, LWCalendarSelectionType) {
    LWCalendarSelectionTypeSingle = 0,          // 单选
    LWCalendarSelectionTypeMultiple = 1,        // 多选
    LWCalendarSelectionTypeRange = 2            // 范围选择
};

@class LWDayView,LWDateHelper,LWDatePickerDialog;

@interface LWCalendarManager : NSObject
@property (nonatomic, strong) LWDateHelper *helper;
@property (nonatomic, strong) NSDateFormatter *titleDateFormatter;
@property (nonatomic, strong) NSDateFormatter *dayDateFormatter;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

// 多选模式中保存选中的时间
@property (nonatomic, strong)NSMutableArray *selectedDateArray;

// 选择模式 默认单选
@property (nonatomic, assign) LWCalendarSelectionType selectionType;

// 之前的时间是否可以被点击选择
@property (nonatomic, assign) BOOL canSelectPastDays;
 

@end
