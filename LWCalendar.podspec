#
# Be sure to run `pod lib lint LWCalendar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LWCalendar'
  s.version          = '0.1.0'
  s.summary          = 'Material Design Style Calendar for IOS.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This is a date picker with material design style. I have searched around for such a project and I get nothing.
People seem to like useing the date picker offered by IOS system. So I start this project for someone else sufferring from date picker.

Hope you enjoy.

If you want to contribut to this project,please email "1071932819@qq.com".
                       DESC

  s.homepage         = 'https://github.com/luwei2012/LWCalender'
  s.screenshots      = "luwei2012.github.io/images/IOS/CustomView/ZYCalender_Record.gif"
  s.license          = { :type => 'GNU', :file => 'LICENSE' }
  s.author           = { '1071932819@qq.com' => 'luwei2012' }
  s.source           = { :git => 'https://github.com/luwei2012/LWCalender.git', :tag => s.version.to_s }
  s.social_media_url = "http://luwei2012.github.io"

  s.ios.deployment_target = '7.0'

  s.source_files = 'LWCalendar/Classes/**/*'
  
  s.resource = 'LWCalendar/Assets/**/*'

end
