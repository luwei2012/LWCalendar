//
//  ZYDayView.m
//  Example
//
//  Created by Daniel on 16/10/28.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import "ZYDayView.h"
#import "JTDateHelper.h"
#import "ZYMonthView.h"

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
    [self setImage:nil forState:UIControlStateNormal];
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
    if (_manager.selectedStartDay && _manager.selectedEndDay) {
        if ([_manager.helper date:_date isEqualOrAfter:_manager.selectedStartDay.date andEqualOrBefore:_manager.selectedEndDay.date]){
            if ([_manager.helper date:_date isTheSameDayThan:_manager.selectedStartDay.date]) {
                [self startStateList];
            } else if ([_manager.helper date:_date isTheSameDayThan:_manager.selectedEndDay.date]) {
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
    if ([_manager.helper date:_date isEqualOrAfter:_manager.selectedStartDay.date andEqualOrBefore:_manager.selectedEndDay.date]) {
        // 同一个月
        if ([_manager.helper date:_manager.selectedStartDay.date isTheSameMonthThan:_manager.selectedEndDay.date]) {
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
            if ([_manager.helper date:_date isTheSameDayThan:[_manager.helper firstDayOfMonth:_manager.selectedStartDay.date]] && !self.enabled) {
                self.backgroundColor = [UIColor clearColor];
            }
            
            // 结束是一个月最后一天
            if ([_manager.helper date:_date isTheSameDayThan:[_manager.helper lastDayOfMonth:_manager.selectedEndDay.date]] && !self.enabled) {
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
        if (!_manager.canSelectPastDays &&
            ![_manager.helper date:_date isTheSameDayThan:_manager.date] &&
            [_date compare:_manager.date] == NSOrderedAscending) {
            self.enabled = false;
        }
        
        [self setTitle:[_manager.dayDateFormatter stringFromDate:_date] forState:UIControlStateNormal];
        
        // 当前时间
        if ([_manager.helper date:_date isTheSameDayThan:_manager.date] && self.enabled) {
            [self setImage:[UIImage imageNamed:@"circle_cir"] forState:UIControlStateNormal];
        }
        
        // 多选状态设置
        if (_manager.selectionType == ZYCalendarSelectionTypeMultiple) {
            for (NSDate *date in _manager.selectedDateArray) {
                self.selected = [_manager.helper date:_date isTheSameDayThan:date];
                if (self.selected) {
                    break;
                }
            }
            return;
        }
        
        // 开始
        if (_manager.selectedStartDay) {
            if ([_manager.helper date:_date isTheSameDayThan:_manager.selectedStartDay.date]) {
                self.manager.selectedStartDay.selected = false;
                self.manager.selectedStartDay = self;
                self.manager.selectedStartDay.selected = true;
            }
        }
        // 结束
        if (_manager.selectedEndDay) {
            if ([_manager.helper date:_date isTheSameDayThan:_manager.selectedEndDay.date]) {
                self.manager.selectedEndDay.selected = false;
                self.manager.selectedEndDay = self;
                self.manager.selectedEndDay.selected = true;
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
    if (_manager.selectionType == ZYCalendarSelectionTypeMultiple) {
        self.selected = !self.selected;
        if (self.selected) {
            [_manager.selectedDateArray addObject:self.date];
        } else {
            [_manager.selectedDateArray enumerateObjectsUsingBlock:^(NSDate *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([_manager.helper date:_date isTheSameDayThan:obj]) {
                    [_manager.selectedDateArray removeObjectAtIndex:idx];
                }
            }];
        }
    } else {
        //目前只有开始时间，没有选择结束时间，则当前选择的就是结束时间
        if (_manager.selectedStartDay && !_manager.selectedEndDay) {
            if (self == _manager.selectedStartDay) {
                //开始时间和结束时间是同一天 不处理
                return;
            }
            //如果选择的结束时间比开始时间早，则将当前选择的日期设置为开始时间 原来的开始时间变成结束时间
            if ([_manager.helper date:_date isBefore:_manager.selectedStartDay.date]) {
                ZYDayView *tmp = self.manager.selectedStartDay;
                self.manager.selectedStartDay.selected = false;
                self.manager.selectedStartDay = self;
                self.manager.selectedStartDay.selected = true;
                self.manager.selectedEndDay.selected = false;
                self.manager.selectedEndDay = tmp;
                self.manager.selectedEndDay.selected = true;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeState" object:nil];
            } else {
                // 如果不能选择时间段(单选)
                if (_manager.selectionType == ZYCalendarSelectionTypeSingle) {
                    self.manager.selectedStartDay.selected = false;
                    self.manager.selectedStartDay = self;
                    self.manager.selectedStartDay.selected = true;
                } else {
                    // 多选
                    self.manager.selectedEndDay.selected = false;
                    self.manager.selectedEndDay = self;
                    self.manager.selectedEndDay.selected = true;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeState" object:nil];
                }
            }
        } else if (_manager.selectedStartDay && _manager.selectedEndDay) {
            self.manager.selectedStartDay.selected = false;
            self.manager.selectedEndDay.selected = false;
            
            self.manager.selectedStartDay = self;
            self.manager.selectedStartDay.selected = true;
            self.manager.selectedEndDay = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeState" object:nil];
        } else if (!_manager.selectedStartDay && !_manager.selectedEndDay) {
            self.manager.selectedStartDay.selected = false;
            self.manager.selectedStartDay = self;
            self.manager.selectedStartDay.selected = true;
        }
    }
    if (self.manager.dayViewBlock) {
        self.manager.dayViewBlock(_date);
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
