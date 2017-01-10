//
//  LWDatePickerBuilder.h
//  Pods
//
//  Created by luwei on 2017/1/9.
//
//

#import <UIKit/UIKit.h>

@interface LWDatePickerBuilder : NSObject

//日期选择器容器的默认配置的圆角
@property (nonatomic, assign) CGFloat LWDatePickerDialogCorner;
//日期选择器容器水平方向边距 决定了选择器的宽度
@property (nonatomic, assign) CGFloat LWDatePickerDialogMarginH;
//日期选择器容器垂直方向边距 决定了选择器的高度
@property (nonatomic, assign) CGFloat LWDatePickerDialogMarginV;
//日期选择器容器显示和隐藏的动画时间
@property (nonatomic, assign) CGFloat LWDatePickerDialogAnimateDutation;

//选中状态的颜色 这里默认使用的是绿色
@property (nonatomic, strong) UIColor *LWDatePickerViewSelectedColor;
//选中状态的文字颜色 绿色的背景+白色的文字
@property (nonatomic, strong) UIColor *LWDatePickerViewSelectedTextColor;
//默认普通状态颜色  白色背景
@property (nonatomic, strong) UIColor *LWDatePickerViewDefaultColor;
//默认普通状态的文字是黑色  白色背景+黑色文字
@property (nonatomic, strong) UIColor *LWDatePickerViewDefaultTextColor;
//LWDatePickerView阴影的配置参数
@property (nonatomic, assign) CGFloat LWDatePickerViewShadowRadius;
@property (nonatomic, strong) UIColor *LWDatePickerViewShadowColor;
@property (nonatomic, assign) CGSize LWDatePickerViewShadowOffset;
@property (nonatomic, assign) CGFloat LWDatePickerViewShadowOpacity;

//功能按钮水平方向的间距：主要是指cancel和confirm按钮之间的间距
@property (nonatomic, assign) CGFloat LWDatePickerViewButtonMarginH;
//功能按钮的高度：主要是指cancel和confirm按钮的高度
@property (nonatomic, assign) CGFloat LWDatePickerViewButtonHeight;
//功能按钮的宽度相对LWDatePickerView宽度的比例：主要是指cancel和confirm按钮的宽度
@property (nonatomic, assign) CGFloat LWDatePickerViewButtonWidth;
//功能按钮的字体大小：主要是指cancel和confirm按钮的字体
@property (nonatomic, strong) UIFont *LWDatePickerViewButtonFont ;

//指示器的title默认高度 整个指示器高度为title高度+日期提示label高度 日期提示label高度默认为title高度的1.5倍
@property (nonatomic, assign) CGFloat LWDateIndicatorTitleHeight;
//指示器上的title字体大小
@property (nonatomic, strong) UIFont *LWDateIndicatorTitleFont;
//指示器上的选中日期提示文字的字体大小
@property (nonatomic, strong) UIFont *LWDateIndicatorDateFont;

//LWCalendarView设置
//月历距离父容器的左右留白
@property (nonatomic, assign) CGFloat LWCalendarMarginH;
//月历行间距
@property (nonatomic, assign) CGFloat LWCalendarLineGap;
//月历列间距
@property (nonatomic, assign) CGFloat LWCalendarRowGap;
//月历有一个标题 显示当前月历是2016年8月 标题字体大小
@property (nonatomic, strong) UIFont *LWCalendarTitleFont;
//月历标题高度
@property (nonatomic, assign) CGFloat LWCalendarTitleHeight;

//week指示器 字体颜色
@property (nonatomic, strong) UIColor *LWWeekIndicatorTextColor;
//week指示器 字体大小
@property (nonatomic, strong) UIFont *LWWeekIndicatorTextFont;
//week指示器 高度
@property (nonatomic, assign) CGFloat LWWeekIndicatorHeight;

//日期选择器中LWDayView的文字字体大小
@property (nonatomic, strong) UIFont *LWDayViewFont;

+(LWDatePickerBuilder *)defaultBuilder;

@end
