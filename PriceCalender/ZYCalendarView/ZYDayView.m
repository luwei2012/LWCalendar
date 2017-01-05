//
//  ZYDayView.m
//  Example
//
//  Created by Daniel on 16/10/28.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import "ZYCalendarHeader.h"

static UIImage * selectImage = nil;

@interface ZYDayView (){
    int selectFlag;
}
@property(nonatomic, weak) ZYCalendarManager *manager;
@property(nonatomic, weak) ZYCalendarView *calendarDelegate;
@end

@implementation ZYDayView

@synthesize weekDelegate = _weekDelegate;

//根据frame获取半径 去宽高中较小的一边作为直径
+(float)radiusFromFrame:(CGRect)frame{
    float width = frame.size.width * 0.5f;
    float height = frame.size.height * 0.5f;
    return width > height ? width : height;
}

+ (UIImage *) roundCorneredImage: (UIImage *) orig radius:(CGFloat) corner {
    UIGraphicsBeginImageContextWithOptions(orig.size, NO, 0);
    [[UIBezierPath bezierPathWithRoundedRect:(CGRect){CGPointZero, orig.size}
                                cornerRadius:corner] addClip];
    [orig drawInRect:(CGRect){CGPointZero, orig.size}];
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}


+(UIImage *) createImageWithColor:(UIColor*) color Frame:(CGRect)frame Radius:(CGFloat)corner{
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, frame);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return (corner > 0 ? [ZYDayView roundCorneredImage:theImage radius:corner]:theImage);
}

+(UIImage *)getSelectImageWithFrame:(CGRect) vframe{
    CGRect frame = CGRectMake(0, 0, vframe.size.width, vframe.size.height);
    if (selectImage == nil) {
        selectImage = [ZYDayView createImageWithColor:SelectedBgColor
                                                Frame:frame
                                               Radius:[ZYDayView radiusFromFrame:frame]];
    }else{
        if(!selectImage.size.height == frame.size.height
           || !selectImage.size.width == frame.size.width){
            selectImage = [ZYDayView createImageWithColor:SelectedBgColor
                                                    Frame:frame
                                                   Radius:[ZYDayView radiusFromFrame:frame]];
        }
    }
    return selectImage;
}

#pragma mark 构造函数
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self normalStateList];
        
        [self addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeState) name:ZYDAYVIEW_CHANGE_STATE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateState) name:ZYDAYVIEW_UPDATE_STATE object:nil];
    }
    return self;
}

#pragma mark 析构函数
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
}

#pragma mark 不同状态下不同按钮的state
//多选状态下除去起始和结束按钮的state
-(void)multiNormalStateList{
    //正常状态 多选情况下中间的按钮状态都不是selected只有两头是 所以正常情况就应该是选中状态
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setImage:nil forState:UIControlStateNormal];
    [self setBackgroundImage:nil forState:UIControlStateNormal];
    //高亮状态
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setImage:nil forState:UIControlStateHighlighted];
    [self setBackgroundImage:nil forState:UIControlStateHighlighted];
    //选中状态
    [self setTitleColor:[UIColor whiteColor]  forState:UIControlStateSelected];
    [self setImage:nil forState:UIControlStateSelected];
    [self setBackgroundImage:nil forState:UIControlStateSelected];
    
}

//普通按钮的state
-(void)normalStateList{
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    //正常状态
    [self setTitleColor:defaultTextColor forState:UIControlStateNormal];
    // 当前时间
    if (_date && [self.manager.helper date:_date isTheSameDayThan:self.calendarDelegate.currentDate] && self.enabled) {
        [self setImage:[UIImage imageNamed:@"circle_cir"] forState:UIControlStateNormal];
    }else{
        [self setImage:nil forState:UIControlStateNormal];
    }
    [self setBackgroundImage:nil forState:UIControlStateNormal];
    //高亮状态
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setImage:[ZYDayView getSelectImageWithFrame:self.frame] forState:UIControlStateHighlighted];
    [self setBackgroundImage:nil forState:UIControlStateHighlighted];
    //选中状态
    [self setTitleColor:[UIColor whiteColor]  forState:UIControlStateSelected];
    [self setImage:[ZYDayView getSelectImageWithFrame:self.frame] forState:UIControlStateSelected];
    [self setBackgroundImage:nil forState:UIControlStateSelected];
}

//起始按钮的state
-(void)startStateList{
    //正常状态
    //    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:defaultTextColor forState:UIControlStateNormal];
    [self setImage:nil forState:UIControlStateNormal];
    [self setBackgroundImage:nil forState:UIControlStateNormal];
    //高亮状态
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setImage:[ZYDayView getSelectImageWithFrame:self.frame] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageNamed:@"backImg_start"] forState:UIControlStateHighlighted];
    //选中状态
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self setImage:[ZYDayView getSelectImageWithFrame:self.frame] forState:UIControlStateSelected];
    [self setBackgroundImage:[UIImage imageNamed:@"backImg_start"] forState:UIControlStateSelected];
}

//结束按钮的state
-(void)endStateList{
    //正常状态
    //    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:defaultTextColor forState:UIControlStateNormal];
    [self setImage:nil forState:UIControlStateNormal];
    [self setBackgroundImage:nil forState:UIControlStateNormal];
    //高亮状态
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setImage:[ZYDayView getSelectImageWithFrame:self.frame] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageNamed:@"backImg_end"] forState:UIControlStateHighlighted];
    //选中状态
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self setImage:[ZYDayView getSelectImageWithFrame:self.frame] forState:UIControlStateSelected];
    [self setBackgroundImage:[UIImage imageNamed:@"backImg_end"] forState:UIControlStateSelected];
}

#pragma mark Notification回调函数
//ZYDayView点击事件通知
- (void)changeState {
    if (self.manager.selectedStartDay && self.manager.selectedEndDay && ![self.manager.helper date:self.calendarDelegate.startDate isTheSameDayThan:self.calendarDelegate.endDate]) {
        if ([self.manager.helper date:_date isEqualOrAfter:self.calendarDelegate.startDate andEqualOrBefore:self.calendarDelegate.endDate]){
            if ([self.manager.helper date:_date isTheSameDayThan:self.calendarDelegate.startDate]) {
                [self startStateList];
            } else if ([self.manager.helper date:_date isTheSameDayThan:self.calendarDelegate.endDate]) {
                [self endStateList];
            }else{
                [self multiNormalStateList];
            }
        }else{
            [self normalStateList];
        }
        [self setSelectColor];
        
    } else {
        self.backgroundColor = [UIColor clearColor];
        [self normalStateList];
    }
}
//start或者end的date改变通知 逻辑应该与changeState类似
-(void)updateState{
    [self setDate:_date];
}

//设置选中状态对应的背景色
- (void)setSelectColor {
    //处于开始和结束时间范围内
    if ([self.manager.helper date:_date
                   isEqualOrAfter:self.calendarDelegate.startDate
                 andEqualOrBefore:self.calendarDelegate.endDate]) {
        // 同一个月
        if ([self.manager.helper date:self.calendarDelegate.startDate
                   isTheSameMonthThan:self.calendarDelegate.endDate]) {
            if (self.enabled) {
                self.backgroundColor = SelectedBgColor;
            } else {
                self.backgroundColor = [UIColor clearColor];
            }
        }
        // 不同
        else {
            //不同月份之间需要注意没有显示日期的ZYDayView，因此首先默认都显示选中背景
            self.backgroundColor = SelectedBgColor;
            // 开始的是一个月的第一天
            if ([self.manager.helper date:_date
                         isTheSameDayThan:[self.manager.helper firstDayOfMonth:self.calendarDelegate.startDate]] && !self.enabled) {
                self.backgroundColor = [UIColor clearColor];
            }
            
            // 结束是一个月最后一天
            if ([self.manager.helper date:_date
                         isTheSameDayThan:[self.manager.helper lastDayOfMonth:self.calendarDelegate.endDate]] && !self.enabled) {
                self.backgroundColor = [UIColor clearColor];
            }
        }
    } else {
        //在选中时间范围外
        self.backgroundColor = [UIColor clearColor];
    }
}


#pragma mark 触摸事件处理
//每次touch开始时将select状态置为false touch结束后状态还原 这是为了能让我们的按钮显示正常
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    selectFlag = self.state & UIControlStateSelected;
    self.selected = false;
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    //    self.selected = selectFlag;
    self.selected = true;
}

#pragma mark 按钮点击事件
-(void)onClick{
    // 多选
    if (self.manager.selectionType == ZYCalendarSelectionTypeMultiple) {
        self.selected = !self.selected;
        if (self.selected) {
            [self.manager.selectedDateArray addObject:self.date];
        } else {
            [self.manager.selectedDateArray enumerateObjectsUsingBlock:^(NSDate *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([self.manager.helper date:_date isTheSameDayThan:obj]) {
                    [self.manager.selectedDateArray removeObjectAtIndex:idx];
                }
            }];
        }
    } else {
        //目前只有开始时间，没有选择结束时间，则当前选择的就是结束时间
        if (self.manager.selectedStartDay && !self.manager.selectedEndDay) {
            //如果选择的结束时间比开始时间早，则将当前选择的日期设置为开始时间 原来的开始时间变成结束时间
            if ([self.manager.helper date:_date isBefore:self.calendarDelegate.startDate]) {
                ZYDayView *tmp = self.manager.selectedStartDay;
                self.manager.selectedStartDay = self;
                self.manager.selectedStartDay.selected = true;
                self.manager.selectedEndDay = tmp;
                self.manager.selectedEndDay.selected = true;
                [[NSNotificationCenter defaultCenter] postNotificationName:ZYDAYVIEW_CHANGE_STATE object:nil];
            } else {
                // 如果不能选择时间段(单选)
                if (self.manager.selectionType == ZYCalendarSelectionTypeSingle) {
                    if (self.manager.selectedStartDay) {
                        self.manager.selectedStartDay.selected = false;
                    }
                    self.manager.selectedStartDay = self;
                    self.manager.selectedStartDay.selected = true;
                } else {
                    self.manager.selectedEndDay = self;
                    self.manager.selectedEndDay.selected = true;
                    [[NSNotificationCenter defaultCenter] postNotificationName:ZYDAYVIEW_CHANGE_STATE object:nil];
                }
            }
        } else if (self.manager.selectedStartDay && self.manager.selectedEndDay) {
            self.manager.selectedStartDay.selected = false;
            self.manager.selectedEndDay.selected = false;
            self.manager.selectedStartDay = self;
            self.manager.selectedStartDay.selected = true;
            self.manager.selectedEndDay = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:ZYDAYVIEW_CHANGE_STATE object:nil];
        } else if (!self.manager.selectedStartDay && !self.manager.selectedEndDay) {
            self.manager.selectedStartDay = self;
            self.manager.selectedStartDay.selected = true;
        }
    }
}

#pragma mark Override函数 确定title和image的坐标
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect frame = contentRect;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size = self.frame.size;
    return frame;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGRect frame = contentRect;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size = self.frame.size;
    return frame;
}

#pragma mark Get and Set
-(void)setWeekDelegate:(ZYWeekView *)weekDelegate{
    _weekDelegate = weekDelegate;
    _manager = _weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager;
    _calendarDelegate = _weekDelegate.monthDelegate.calendarDelegate;
}

- (void)setDate:(NSDate *)date {
    _date = date;
    
    if (self.enabled) {
        
        // 过去的时间能否点击
        if (!self.manager.canSelectPastDays &&
            ![self.manager.helper date:_date isTheSameDayThan:self.calendarDelegate.currentDate] &&
            [_date compare:self.calendarDelegate.currentDate] == NSOrderedAscending) {
            self.enabled = false;
        }
        
        [self setTitle:[self.manager.dayDateFormatter stringFromDate:_date] forState:UIControlStateNormal];
        
        // 当前时间
        if ([self.manager.helper date:_date isTheSameDayThan:self.calendarDelegate.currentDate] && self.enabled) {
            [self setImage:[UIImage imageNamed:@"circle_cir"] forState:UIControlStateNormal];
        }
        
        // 多选状态设置
        if (self.manager.selectionType == ZYCalendarSelectionTypeMultiple) {
            for (NSDate *date in self.manager.selectedDateArray) {
                self.selected = [self.manager.helper date:_date isTheSameDayThan:date];
                if (self.selected) {
                    break;
                }
            }
            return;
        }
        
        // 开始
        if (self.calendarDelegate.startDate) {
            if ([self.manager.helper date:_date isTheSameDayThan:self.calendarDelegate.startDate]) {
                if (self.manager.selectedStartDay) {
                    self.manager.selectedStartDay.selected = false;
                }
                self.manager.selectedStartDay = self;
                self.manager.selectedStartDay.selected = true;
            }
        }
        // 结束
        if (self.manager.selectedEndDay) {
            if ([self.manager.helper date:_date isTheSameDayThan:self.calendarDelegate.endDate]) {
                if (self.manager.selectedEndDay) {
                    self.manager.selectedEndDay.selected = false;
                }
                self.manager.selectedEndDay = self;
                self.manager.selectedEndDay.selected = true;
            }
        }
        
    }
    [self changeState];
}

@end
