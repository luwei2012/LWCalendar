//
//  LWDayView.h
//  Example
//
//  Created by Daniel on 16/10/28.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h> 

@class LWWeekView, LWDatePickerBuilder;

@interface LWDayView : UIButton
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, weak) LWWeekView *weekDelegate;
@property (nonatomic, weak) LWDatePickerBuilder *dialogBuilder;
@end
