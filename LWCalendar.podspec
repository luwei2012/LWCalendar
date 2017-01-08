#
#  Be sure to run `pod spec lint LWCalendar.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|


  s.name         = "LWCalendar"
  s.version      = "0.0.1"
  s.summary      = "Material Design Style Calendar for IOS."


  s.description  = <<-DESC
This is a date picker with material design style. I have searched around for such a project and I get nothing.
People seem to like useing the date picker offered by IOS system. So I start this project for someone else sufferring from date picker. Hope you enjoy.
If you want to contribut to this project,please email "1071932819@qq.com".
                   DESC

  s.homepage     = "https://github.com/luwei2012/LWCalender"
  s.screenshots  = "luwei2012.github.io/images/IOS/CustomView/ZYCalender_Record.gif"



  s.license      = "GNU"


  s.author             = "luwei2012"
  s.social_media_url   = "http://luwei2012.github.io"


  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/luwei2012/LWCalender.git", :tag => "#{s.version}" }

  s.source_files  = 'LWCalendarView/Classes/**/*'
  s.resource_bundles = {
     'LWCalendar' => ['LWCalendarView/Assets/**/*']
  }

  s.public_header_files = "Classes/LWCalendarHeader.h"


end
