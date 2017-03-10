//
//  SKCalendarView.h
//  HoveringNavigationBar
//
//  Created by sunshuaikun on 17/3/9.
//  Copyright © 2017年 sunshuaikun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_MAIN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_MAIN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define RGBCOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define kFloatingViewMinimumHeight 64
#define kFloatingViewMaximumHeight 224

@interface SKCalendarView : UIView

@end
