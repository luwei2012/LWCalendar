//
//  LWDatePickerBuilder.m
//  Pods
//
//  Created by luwei on 2017/1/9.
//
//

#import "LWCalendarHeader.h"

#define UNINITIALIZED_FLOAT (-MAXFLOAT)
#define UNINITIALIZED_CGSIZE (CGSizeMake(UNINITIALIZED_FLOAT,UNINITIALIZED_FLOAT))

//日期选择器容器的默认配置的圆角 --LWDatePickerDialog
#define LWDATEPICKERDIALOG_CORNER  (4)
//日期选择器容器水平方向边距 决定了选择器的宽度
#define LWDATEPICKERDIALOG_MARGIN_H (60)
//日期选择器容器垂直方向边距 决定了选择器的高度
#define LWDATEPICKERDIALOG_MARGIN_V (60)
//日期选择器容器显示和隐藏的动画时间
#define ANIMATE_DUTATION (0.5)


//日期选择器 月历View的默认配置 --LWDatePickerView
//选中状态的颜色 这里默认使用的是绿色
#define LWDATEPICKERVIEW_SELECTED_COLOR LWHEXCOLOR(0x128963)
//选中状态的文字颜色 绿色的背景+白色的文字
#define LWDATEPICKERVIEW_SELECTED_TEXT_COLOR [UIColor whiteColor]
//默认普通状态的颜色 这里默认使用的是白色
#define LWDATEPICKERVIEW_DEFAULT_COLOR [UIColor whiteColor]
//默认普通状态的文字是黑色  白色背景+黑色文字
#define LWDATEPICKERVIEW_DEFAULT_TEXT_COLOR [UIColor blackColor]
//LWDatePickerView阴影的配置参数
#define LWDATEPICKERVIEW_SHADOW_RADIUS (8.0)
#define LWDATEPICKERVIEW_SHADOW_COLOR ([UIColor blackColor])
#define LWDATEPICKERVIEW_SHADOW_OFFSET (CGSizeMake(2, 2))
#define LWDATEPICKERVIEW_SHADOW_OPACITY (0.6)

//LWCalendarView设置
//月历距离父容器的左右留白
#define LWCALENDARVIEW_MARGIN_H (10.0)
//月历行间距
#define LWCALENDARVIEW_LINE_GAP (4.0)
//月历列间距
#define LWCALENDARVIEW_ROW_GAP (4.0)
//月历有一个标题 显示当前月历是2016年8月 标题字体大小
#define LWCALENDARVIEW_TITLE_FONT_SIZE (15)
//月历标题高度
#define LWCALENDARVIEW_TITLE_HEIGHT (40.0)

//功能按钮水平方向的间距：主要是指cancel和confirm按钮之间的间距
#define LWDATEPICKERVIEW_BUTTON_MARGIN_H (5)
//功能按钮的高度：主要是指cancel和confirm按钮的高度
#define LWDATEPICKERVIEW_BUTTON_HEIGHT (48)
//功能按钮的宽度相对LWDatePickerView宽度的比例：主要是指cancel和confirm按钮的宽度
#define LWDATEPICKERVIEW_BUTTON_WIDTH (0.25)
//功能按钮的字体大小：主要是指cancel和confirm按钮的字体大小
#define LWDATEPICKERVIEW_BUTTON_FONT_SIZE (16)

//From/To指示器的默认配置 --LWDateIndicator
//From/To指示器的title默认高度 整个指示器高度为title高度+日期提示label高度 日期提示label高度默认为title高度的1.5倍
#define LWDATEINICATOR_TITLE_HEIGHT (48)
//From/To指示器上的title字体大小
#define LWDATEINICATOR_TITLE_FONT_SIZE (16)
//From/To指示器上的选中日期提示文字的字体大小
#define LWDATEINICATOR_DATE_FONT_SIZE (16)

//week指示器 字体颜色
#define LWWEEKINICATOR_TEXT_COLOR LWHEXCOLOR(0x666666)
//week指示器 字体大小
#define LWWEEKINICATOR_FONT_SIZE (12)
//week指示器 高度
#define LWWEEKINICATOR_HEIGHT (20.0)

//日期选择器中LWDayView的文字字体大小
#define LWDAYVIEW_FONT_SIZE (12)


static LWDatePickerBuilder *defaultInstance;

@implementation LWDatePickerBuilder

@synthesize
LWDatePickerDialogCorner            = _LWDatePickerDialogCorner,
LWDatePickerDialogMarginH           = _LWDatePickerDialogMarginH,
LWDatePickerDialogMarginV           = _LWDatePickerDialogMarginV,
LWDatePickerDialogAnimateDutation   = _LWDatePickerDialogAnimateDutation,

LWDatePickerViewSelectedColor       = _LWDatePickerViewSelectedColor,
LWDatePickerViewSelectedTextColor   = _LWDatePickerViewSelectedTextColor,
LWDatePickerViewDefaultColor        = _LWDatePickerViewDefaultColor,
LWDatePickerViewDefaultTextColor    = _LWDatePickerViewDefaultTextColor,
LWDatePickerViewShadowColor         = _LWDatePickerViewShadowColor,
LWDatePickerViewShadowRadius        = _LWDatePickerViewShadowRadius,
LWDatePickerViewShadowOffset        = _LWDatePickerViewShadowOffset,
LWDatePickerViewShadowOpacity       = _LWDatePickerViewShadowOpacity,

LWDatePickerViewButtonMarginH       = _LWDatePickerViewButtonMarginH,
LWDatePickerViewButtonHeight        = _LWDatePickerViewButtonHeight,
LWDatePickerViewButtonWidth         = _LWDatePickerViewButtonWidth,
LWDatePickerViewButtonFont          = _LWDatePickerViewButtonFont,

LWCalendarLineGap                   = _LWCalendarLineGap,
LWCalendarMarginH                   = _LWCalendarMarginH,
LWCalendarRowGap                    = _LWCalendarRowGap,
LWCalendarTitleFont                 = _LWCalendarTitleFont,
LWCalendarTitleHeight               = _LWCalendarTitleHeight,

LWDateIndicatorTitleHeight          = _LWDateIndicatorTitleHeight,
LWDateIndicatorDateFont             = _LWDateIndicatorDateFont,
LWDateIndicatorTitleFont            = _LWDateIndicatorTitleFont,

LWWeekIndicatorTextColor            = _LWWeekIndicatorTextColor,
LWWeekIndicatorTextFont             = _LWWeekIndicatorTextFont,
LWWeekIndicatorHeight               = _LWWeekIndicatorHeight,

LWDayViewFont                       = _LWDayViewFont;

-(instancetype)init{
    if (self = [super init]) {
        self.LWDatePickerDialogCorner           = UNINITIALIZED_FLOAT;
        self.LWDatePickerDialogMarginH          = UNINITIALIZED_FLOAT;
        self.LWDatePickerDialogMarginV          = UNINITIALIZED_FLOAT;
        self.LWDatePickerDialogAnimateDutation  = UNINITIALIZED_FLOAT;
        self.LWDatePickerViewShadowRadius       = UNINITIALIZED_FLOAT;
        self.LWDatePickerViewShadowOffset       = UNINITIALIZED_CGSIZE;
        self.LWDatePickerViewShadowOpacity      = UNINITIALIZED_FLOAT;
        
        self.LWDatePickerViewButtonMarginH      = UNINITIALIZED_FLOAT;
        self.LWDatePickerViewButtonHeight       = UNINITIALIZED_FLOAT;
        self.LWDatePickerViewButtonWidth        = UNINITIALIZED_FLOAT;
        
        self.LWCalendarLineGap                  = UNINITIALIZED_FLOAT;
        self.LWCalendarRowGap                   = UNINITIALIZED_FLOAT;
        self.LWCalendarMarginH                  = UNINITIALIZED_FLOAT;
        self.LWCalendarTitleHeight              = UNINITIALIZED_FLOAT;
        
        self.LWWeekIndicatorHeight              = UNINITIALIZED_FLOAT;
        
        self.LWDateIndicatorTitleHeight         = UNINITIALIZED_FLOAT;
    }
    return self;
}

+(LWDatePickerBuilder *)defaultBuilder{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!defaultInstance) {
            defaultInstance = [[self alloc] init];
            defaultInstance.LWDatePickerDialogCorner            = LWDATEPICKERDIALOG_CORNER;
            defaultInstance.LWDatePickerDialogMarginH           = LWDATEPICKERDIALOG_MARGIN_H;
            defaultInstance.LWDatePickerDialogMarginV           = LWDATEPICKERDIALOG_MARGIN_V;
            defaultInstance.LWDatePickerDialogAnimateDutation   = ANIMATE_DUTATION;
            
            defaultInstance.LWDatePickerViewSelectedColor       = LWDATEPICKERVIEW_SELECTED_COLOR;
            defaultInstance.LWDatePickerViewSelectedTextColor   = LWDATEPICKERVIEW_SELECTED_TEXT_COLOR;
            defaultInstance.LWDatePickerViewDefaultColor        = LWDATEPICKERVIEW_DEFAULT_COLOR;
            defaultInstance.LWDatePickerViewDefaultTextColor    = LWDATEPICKERVIEW_DEFAULT_TEXT_COLOR;
            defaultInstance.LWDatePickerViewShadowColor         = LWDATEPICKERVIEW_SHADOW_COLOR;
            defaultInstance.LWDatePickerViewShadowRadius        = LWDATEPICKERVIEW_SHADOW_RADIUS;
            defaultInstance.LWDatePickerViewShadowOffset        = LWDATEPICKERVIEW_SHADOW_OFFSET;
            defaultInstance.LWDatePickerViewShadowOpacity       = LWDATEPICKERVIEW_SHADOW_OPACITY;
            
            defaultInstance.LWDatePickerViewButtonMarginH       = LWDATEPICKERVIEW_BUTTON_MARGIN_H;
            defaultInstance.LWDatePickerViewButtonHeight        = LWDATEPICKERVIEW_BUTTON_HEIGHT;
            defaultInstance.LWDatePickerViewButtonWidth         = LWDATEPICKERVIEW_BUTTON_WIDTH;
            defaultInstance.LWDatePickerViewButtonFont          = [UIFont boldSystemFontOfSize:LWDATEPICKERVIEW_BUTTON_FONT_SIZE];
            
            defaultInstance.LWCalendarTitleHeight               = LWCALENDARVIEW_TITLE_HEIGHT;
            defaultInstance.LWCalendarTitleFont                 = [UIFont systemFontOfSize:LWCALENDARVIEW_TITLE_FONT_SIZE];
            defaultInstance.LWCalendarMarginH                   = LWCALENDARVIEW_MARGIN_H;
            defaultInstance.LWCalendarLineGap                   = LWCALENDARVIEW_LINE_GAP;
            defaultInstance.LWCalendarRowGap                    = LWCALENDARVIEW_ROW_GAP;
            
            defaultInstance.LWDateIndicatorTitleHeight          = LWDATEINICATOR_TITLE_HEIGHT;
            defaultInstance.LWDateIndicatorDateFont             = [UIFont boldSystemFontOfSize:LWDATEINICATOR_TITLE_FONT_SIZE];
            defaultInstance.LWDateIndicatorTitleFont            = [UIFont boldSystemFontOfSize:LWDATEINICATOR_DATE_FONT_SIZE];
            
            defaultInstance.LWWeekIndicatorTextColor            = LWWEEKINICATOR_TEXT_COLOR;
            defaultInstance.LWWeekIndicatorTextFont             = [UIFont systemFontOfSize:LWWEEKINICATOR_FONT_SIZE];
            defaultInstance.LWWeekIndicatorHeight               = LWWEEKINICATOR_HEIGHT;
            
            defaultInstance.LWDayViewFont                       = [UIFont systemFontOfSize:LWDAYVIEW_FONT_SIZE];
        }
    });
    //初始化代码
    return defaultInstance;
}

-(CGFloat)LWDatePickerDialogCorner{
    if (_LWDatePickerDialogCorner == UNINITIALIZED_FLOAT) {
        _LWDatePickerDialogCorner = [LWDatePickerBuilder defaultBuilder].LWDatePickerDialogCorner;
    }
    return _LWDatePickerDialogCorner;
}

-(CGFloat)LWDatePickerDialogMarginH{
    if (_LWDatePickerDialogMarginH == UNINITIALIZED_FLOAT) {
        _LWDatePickerDialogMarginH = [LWDatePickerBuilder defaultBuilder].LWDatePickerDialogMarginH;
    }
    return _LWDatePickerDialogMarginH;
}

-(CGFloat)LWDatePickerDialogMarginV{
    if (_LWDatePickerDialogMarginV == UNINITIALIZED_FLOAT) {
        _LWDatePickerDialogMarginV = [LWDatePickerBuilder defaultBuilder].LWDatePickerDialogMarginV;
    }
    return _LWDatePickerDialogMarginV;
}

-(CGFloat)LWDatePickerDialogAnimateDutation{
    if (_LWDatePickerDialogAnimateDutation == UNINITIALIZED_FLOAT) {
        _LWDatePickerDialogAnimateDutation = [LWDatePickerBuilder defaultBuilder].LWDatePickerDialogAnimateDutation;
    }
    return _LWDatePickerDialogAnimateDutation;
}

-(CGFloat)LWDatePickerViewShadowRadius{
    if (_LWDatePickerViewShadowRadius == UNINITIALIZED_FLOAT) {
        _LWDatePickerViewShadowRadius = [LWDatePickerBuilder defaultBuilder].LWDatePickerViewShadowRadius;
    }
    return _LWDatePickerViewShadowRadius;
}

-(CGFloat)LWDatePickerViewShadowOpacity{
    if (_LWDatePickerViewShadowOpacity == UNINITIALIZED_FLOAT) {
        _LWDatePickerViewShadowOpacity = [LWDatePickerBuilder defaultBuilder].LWDatePickerViewShadowOpacity;
    }
    return _LWDatePickerViewShadowOpacity;
}

-(CGFloat)LWDatePickerViewButtonMarginH{
    if (_LWDatePickerViewButtonMarginH == UNINITIALIZED_FLOAT) {
        _LWDatePickerViewButtonMarginH = [LWDatePickerBuilder defaultBuilder].LWDatePickerViewButtonMarginH;
    }
    return _LWDatePickerViewButtonMarginH;
}

-(CGFloat)LWDatePickerViewButtonHeight{
    if (_LWDatePickerViewButtonHeight == UNINITIALIZED_FLOAT) {
        _LWDatePickerViewButtonHeight = [LWDatePickerBuilder defaultBuilder].LWDatePickerViewButtonHeight;
    }
    return _LWDatePickerViewButtonHeight;
}

-(CGFloat)LWDatePickerViewButtonWidth{
    if (_LWDatePickerViewButtonWidth == UNINITIALIZED_FLOAT) {
        _LWDatePickerViewButtonWidth = [LWDatePickerBuilder defaultBuilder].LWDatePickerViewButtonWidth;
    }
    return _LWDatePickerViewButtonWidth;
}

-(CGFloat)LWDateIndicatorTitleHeight{
    if (_LWDateIndicatorTitleHeight == UNINITIALIZED_FLOAT) {
        _LWDateIndicatorTitleHeight = [LWDatePickerBuilder defaultBuilder].LWDateIndicatorTitleHeight;
    }
    return _LWDateIndicatorTitleHeight;
}

-(CGFloat)LWCalendarLineGap{
    if (_LWCalendarLineGap == UNINITIALIZED_FLOAT) {
        _LWCalendarLineGap = [LWDatePickerBuilder defaultBuilder].LWCalendarLineGap;
    }
    return _LWCalendarLineGap;
}


-(CGFloat)LWCalendarMarginH{
    if (_LWCalendarMarginH == UNINITIALIZED_FLOAT) {
        _LWCalendarMarginH = [LWDatePickerBuilder defaultBuilder].LWCalendarMarginH;
    }
    return _LWCalendarMarginH;
}


-(CGFloat)LWCalendarRowGap{
    if (_LWCalendarRowGap == UNINITIALIZED_FLOAT) {
        _LWCalendarRowGap = [LWDatePickerBuilder defaultBuilder].LWCalendarRowGap;
    }
    return _LWCalendarRowGap;
}


-(CGFloat)LWCalendarTitleHeight{
    if (_LWCalendarTitleHeight == UNINITIALIZED_FLOAT) {
        _LWCalendarTitleHeight = [LWDatePickerBuilder defaultBuilder].LWCalendarTitleHeight;
    }
    return _LWCalendarTitleHeight;
}


-(CGFloat)LWWeekIndicatorHeight{
    if (_LWWeekIndicatorHeight == UNINITIALIZED_FLOAT) {
        _LWWeekIndicatorHeight = [LWDatePickerBuilder defaultBuilder].LWWeekIndicatorHeight;
    }
    return _LWWeekIndicatorHeight;
}


-(UIColor *)LWDatePickerViewSelectedColor{
    if (_LWDatePickerViewSelectedColor == nil) {
        _LWDatePickerViewSelectedColor = [LWDatePickerBuilder defaultBuilder].LWDatePickerViewSelectedColor;
    }
    return _LWDatePickerViewSelectedColor;
}

-(UIColor *)LWDatePickerViewSelectedTextColor{
    if (_LWDatePickerViewSelectedTextColor == nil) {
        _LWDatePickerViewSelectedTextColor = [LWDatePickerBuilder defaultBuilder].LWDatePickerViewSelectedTextColor;
    }
    return _LWDatePickerViewSelectedTextColor;
}

-(UIColor *)LWDatePickerViewDefaultColor{
    if (_LWDatePickerViewDefaultColor == nil) {
        _LWDatePickerViewDefaultColor = [LWDatePickerBuilder defaultBuilder].LWDatePickerViewDefaultColor;
    }
    return _LWDatePickerViewDefaultColor;
}

-(UIColor *)LWDatePickerViewDefaultTextColor{
    if (_LWDatePickerViewDefaultTextColor == nil) {
        _LWDatePickerViewDefaultTextColor = [LWDatePickerBuilder defaultBuilder].LWDatePickerViewDefaultTextColor;
    }
    return _LWDatePickerViewDefaultTextColor;
}

-(UIColor *)LWWeekIndicatorTextColor{
    if (_LWWeekIndicatorTextColor == nil) {
        _LWWeekIndicatorTextColor = [LWDatePickerBuilder defaultBuilder].LWWeekIndicatorTextColor;
    }
    return _LWWeekIndicatorTextColor;
}

-(UIColor *)LWDatePickerViewShadowColor{
    if (_LWDatePickerViewShadowColor == nil) {
        _LWDatePickerViewShadowColor = [LWDatePickerBuilder defaultBuilder].LWDatePickerViewShadowColor;
    }
    return _LWDatePickerViewShadowColor;
}

-(UIFont *)LWDatePickerViewButtonFont{
    if (_LWDatePickerViewButtonFont == nil) {
        _LWDatePickerViewButtonFont = [LWDatePickerBuilder defaultBuilder].LWDatePickerViewButtonFont;
    }
    return _LWDatePickerViewButtonFont;
}

-(UIFont *)LWDateIndicatorDateFont{
    if (_LWDateIndicatorDateFont == nil) {
        _LWDateIndicatorDateFont = [LWDatePickerBuilder defaultBuilder].LWDateIndicatorDateFont;
    }
    return _LWDateIndicatorDateFont;
}

-(UIFont *)LWDateIndicatorTitleFont{
    if (_LWDateIndicatorTitleFont == nil) {
        _LWDateIndicatorTitleFont = [LWDatePickerBuilder defaultBuilder].LWDateIndicatorTitleFont;
    }
    return _LWDateIndicatorTitleFont;
}

-(UIFont *)LWWeekIndicatorTextFont{
    if (_LWWeekIndicatorTextFont == nil) {
        _LWWeekIndicatorTextFont = [LWDatePickerBuilder defaultBuilder].LWWeekIndicatorTextFont;
    }
    return _LWWeekIndicatorTextFont;
}

-(UIFont *)LWDayViewFont{
    if (_LWDayViewFont == nil) {
        _LWDayViewFont = [LWDatePickerBuilder defaultBuilder].LWDayViewFont;
    }
    return _LWDayViewFont;
}

-(UIFont *)LWCalendarTitleFont{
    if (_LWCalendarTitleFont == nil) {
        _LWCalendarTitleFont = [LWDatePickerBuilder defaultBuilder].LWCalendarTitleFont;
    }
    return _LWCalendarTitleFont;
}

-(CGSize)LWDatePickerViewShadowOffset{
    if (_LWDatePickerViewShadowOffset.width == UNINITIALIZED_CGSIZE.width
        && _LWDatePickerViewShadowOffset.height == UNINITIALIZED_CGSIZE.height) {
        _LWDatePickerViewShadowOffset = [LWDatePickerBuilder defaultBuilder].LWDatePickerViewShadowOffset;
    }
    return _LWDatePickerViewShadowOffset;
}

@end
