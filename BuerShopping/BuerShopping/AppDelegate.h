//
//  AppDelegate.h
//  BuerShopping
//
//  Created by 于金祥 on 15/5/30.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBarViewController.h"
#import "FirstScrollController.h"
#import <SMS_SDK/SMS_SDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    CustomTabBarViewController *_tabBarViewCol;
    FirstScrollController *firstCol;
}

- (void)showTabBar;
- (void)hiddenTabBar;
- (void)selectTableBarIndex:(NSInteger)index;
-(CustomTabBarViewController *)getTabBar;
@property (strong, nonatomic) UIWindow *window;


@end

