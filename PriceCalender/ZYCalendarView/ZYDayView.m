//
//  ZYDayView.m
//  Example
//
//  Created by Daniel on 16/10/28.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import "ZYCalendarHeader.h"

static UIImage * selectImage = nil;

@implementation ZYDayView

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


+(UIImage *) createImageWithColor:(UIColor*) color Frame:(CGRect)frame Radius:(CGFloat)corner
{
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


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self normalStateList];
        
        [self addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeState) name:@"changeState" object:nil];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
    
}

#pragma mark 多选状态下出去起始和结束按钮的state
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

#pragma mark 普通按钮的state
-(void)normalStateList{
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    //正常状态
    [self setTitleColor:defaultTextColor forState:UIControlStateNormal];
    // 当前时间
    if (_date && [self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.helper date:_date isTheSameDayThan:self.weekDelegate.monthDelegate.calendarDelegate.currentDate] && self.enabled) {
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

#pragma mark 起始按钮的state
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

#pragma mark 结束按钮的state
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

- (void)changeState {
    if (self.weekDelegate.monthDelegate.calendarDelegate.startDate && self.weekDelegate.monthDelegate.calendarDelegate.endDate) {
        if ([self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.helper date:_date isEqualOrAfter:self.weekDelegate.monthDelegate.calendarDelegate.startDate andEqualOrBefore:self.weekDelegate.monthDelegate.calendarDelegate.endDate]){
            if ([self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.helper date:_date isTheSameDayThan:self.weekDelegate.monthDelegate.calendarDelegate.startDate]) {
                [self startStateList];
            } else if ([self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.helper date:_date isTheSameDayThan:self.weekDelegate.monthDelegate.calendarDelegate.endDate]) {
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

- (void)setSelectColor {
    if ([self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.helper date:_date isEqualOrAfter:self.weekDelegate.monthDelegate.calendarDelegate.startDate andEqualOrBefore:self.weekDelegate.monthDelegate.calendarDelegate.endDate]) {
        // 同一个月
        if ([self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.helper date:self.weekDelegate.monthDelegate.calendarDelegate.startDate isTheSameMonthThan:self.weekDelegate.monthDelegate.calendarDelegate.endDate]) {
            if (self.enabled) {
                self.backgroundColor = SelectedBgColor;
            } else {
                self.backgroundColor = [UIColor clearColor];
            }
        }
        // 不同
        else {
            self.backgroundColor = SelectedBgColor;
            // 开始的是一个月的第一天
            if ([self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.helper date:_date isTheSameDayThan:[self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.helper firstDayOfMonth:self.weekDelegate.monthDelegate.calendarDelegate.startDate]] && !self.enabled) {
                self.backgroundColor = [UIColor clearColor];
            }
            
            // 结束是一个月最后一天
            if ([self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.helper date:_date isTheSameDayThan:[self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.helper lastDayOfMonth:self.weekDelegate.monthDelegate.calendarDelegate.endDate]] && !self.enabled) {
                self.backgroundColor = [UIColor clearColor];
            }
        }
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

- (void)setDate:(NSDate *)date {
    _date = date;
    
    if (self.enabled) {
        
        // 过去的时间能否点击
        if (!self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.canSelectPastDays &&
            ![self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.helper date:_date isTheSameDayThan:self.weekDelegate.monthDelegate.calendarDelegate.currentDate] &&
            [_date compare:self.weekDelegate.monthDelegate.calendarDelegate.currentDate] == NSOrderedAscending) {
            self.enabled = false;
        }
        
        [self setTitle:[self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.dayDateFormatter stringFromDate:_date] forState:UIControlStateNormal];
        
        // 当前时间
        if ([self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.helper date:_date isTheSameDayThan:self.weekDelegate.monthDelegate.calendarDelegate.currentDate] && self.enabled) {
            [self setImage:[UIImage imageNamed:@"circle_cir"] forState:UIControlStateNormal];
        }
        
        // 多选状态设置
        if (self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectionType == ZYCalendarSelectionTypeMultiple) {
            for (NSDate *date in self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedDateArray) {
                self.selected = [self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.helper date:_date isTheSameDayThan:date];
                if (self.selected) {
                    break;
                }
            }
            return;
        }
        
        // 开始
        if (self.weekDelegate.monthDelegate.calendarDelegate.startDate) {
            if ([self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.helper date:_date isTheSameDayThan:self.weekDelegate.monthDelegate.calendarDelegate.startDate]) {
                self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedStartDay.selected = false;
                self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedStartDay = self;
                self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedStartDay.selected = true;
            }
        }
        // 结束
        if (self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedEndDay) {
            if ([self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.helper date:_date isTheSameDayThan:self.weekDelegate.monthDelegate.calendarDelegate.endDate]) {
                self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedEndDay.selected = false;
                self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedEndDay = self;
                self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedEndDay.selected = true;
            }
        }
        
    }
    [self changeState];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.selected = false;
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    self.selected = true;
}

-(void)onClick{
    // 多选
    if (self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectionType == ZYCalendarSelectionTypeMultiple) {
        self.selected = !self.selected;
        if (self.selected) {
            [self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedDateArray addObject:self.date];
        } else {
            [self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedDateArray enumerateObjectsUsingBlock:^(NSDate *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.helper date:_date isTheSameDayThan:obj]) {
                    [self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedDateArray removeObjectAtIndex:idx];
                }
            }];
        }
    } else {
        //目前只有开始时间，没有选择结束时间，则当前选择的就是结束时间
        if (self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedStartDay && !self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedEndDay) {
            if (self == self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedStartDay) {
                //开始时间和结束时间是同一天 不处理
                return;
            }
            //如果选择的结束时间比开始时间早，则将当前选择的日期设置为开始时间 原来的开始时间变成结束时间
            if ([self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.helper date:_date isBefore:self.weekDelegate.monthDelegate.calendarDelegate.startDate]) {
                ZYDayView *tmp = self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedStartDay;
                self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedStartDay.selected = false;
                self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedStartDay = self;
                self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedStartDay.selected = true;
                self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedEndDay.selected = false;
                self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedEndDay = tmp;
                self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedEndDay.selected = true;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeState" object:nil];
            } else {
                // 如果不能选择时间段(单选)
                if (self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectionType == ZYCalendarSelectionTypeSingle) {
                    self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedStartDay.selected = false;
                    self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedStartDay = self;
                    self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedStartDay.selected = true;
                } else {
                    // 多选
                    self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedEndDay.selected = false;
                    self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedEndDay = self;
                    self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedEndDay.selected = true;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeState" object:nil];
                }
            }
        } else if (self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedStartDay && self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedEndDay) {
            self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedStartDay.selected = false;
            self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedEndDay.selected = false;
            
            self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedStartDay = self;
            self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedStartDay.selected = true;
            self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedEndDay = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeState" object:nil];
        } else if (!self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedStartDay && !self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedEndDay) {
            self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedStartDay.selected = false;
            self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedStartDay = self;
            self.weekDelegate.monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager.selectedStartDay.selected = true;
        }
    }
}


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

@end
