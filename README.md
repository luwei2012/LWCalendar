# ZYCalender
参考[ZYCalendarView](https://github.com/Yanyinghenmei/ZYCalendarView) 模仿了Android的material design设计

![calender.gif](http://luwei2012.github.io/images/IOS/CustomView/ZYCalender_Record.gif) 

目前还没有开放定制化的API，想要定制UI只能修改源码
## Usage

1.下载源码，将ZYCalendarView文件夹加入自己的工程
2.在需要使用的地方添加
```objc
	#import "ZYDatePickerDialog.h" 
```
3.实现代理DatePickerDelegate
```objc
    @interface ViewController ()<DatePickerDelegate>

    @end 

    -(void)onDateSet:(ZYDatePickerDialog *)dialog StartDate:(NSDate *)start EndDate:(NSDate *)end{
        NSLog(@"onDateSet");
    }

```
4.创建和显示
```objc
    [[ZYDatePickerDialog initWithDate:[NSDate date] Delegate:self] show]; 
```
## To do

1.更换工程名，写这个库也是一时兴起，都没来得及改名字

2.添加到Pod中，支持pod安装

3.添加UI定制的API

4.寻找UI设计师帮忙设计布局，这个布局还是有点丑......

## Author

luwei2012

## License

CoreTextView is available under the GNU license. See the LICENSE file for more info.
