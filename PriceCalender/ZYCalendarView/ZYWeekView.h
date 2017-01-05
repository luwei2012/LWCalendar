//
//  ZYWeekView.h
//  Example
//
//  Created by Daniel on 16/10/28.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h> 

@class ZYMonthView;

@interface ZYWeekView : UIView
@property (nonatomic, strong) NSDate *theMonthFirstDay;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, weak) ZYMonthView *monthDelegate;

@end
