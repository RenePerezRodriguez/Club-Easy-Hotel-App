# club_easy_hotel

A new Flutter project.

## Create IOS photos using
https://theapplaunchpad.com/dashboard/ios/?platform=ios&template=mwaYYuHn&project=_9bf42263986886b6446433e3b7da3412_1719661997101#
- Convert the photos into png format, via: `mogrify -format png *.jpg`
- Add the photos to the assets folder and upload to appconnect
- 

## IOS deployment
- `flutter pub get`
- `flutter build ios`
- `cd ios/ && pod install` or `pod update`
- `open ios/Runner.xcworkspace`
- In Xcode, select the Runner project in the left hand pane
