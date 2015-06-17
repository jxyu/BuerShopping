//
//  AppDelegate.m
//  BuerShopping
//
//  Created by 于金祥 on 15/5/30.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "AppDelegate.h"
#import "CommenDef.h"
#import "DataProvider.h"

#define appKey @"7bf8c19274e0"
#define appSecret @"a9544d5cdd5854a62ba4f5978be3ef6f"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    /**
     *  短信验证添加
     */
    [SMS_SDK registerApp:appKey withSecret:appSecret];
    
    
    
    /**
     设置根VC
     */
    firstCol=[[FirstScrollController alloc]init];
    _tabBarViewCol = [[CustomTabBarViewController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds] ];
//    if ([get_sp(@"FIRST_ENTER")isEqualToString:@"1"]) {
        self.window.rootViewController =_tabBarViewCol;
//    }
//    else
//    {
//        self.window.rootViewController =firstCol;
//    }
    
    [self.window makeKeyAndVisible];
    //[self getAliPay];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRootView) name:@"changeRootView" object:nil];
    
    [self.window makeKeyAndVisible];
    
    
    
    
    return YES;
}

-(void)changeRootView
{
    self.window.rootViewController=_tabBarViewCol;
}


- (void)showTabBar
{
    [_tabBarViewCol showTabBar];
}
- (void)hiddenTabBar
{
    [_tabBarViewCol hideCustomTabBar];
}
-(CustomTabBarViewController *)getTabBar
{
    return _tabBarViewCol;
}

/**
 *  注册
 *
 *  @param prm 参数
 */
-(void)RegisterUserInfo:(id)prm
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider RegisterUserInfo:prm];
}
/**
 *  登录
 *
 *  @param mobel 手机号
 *  @param pwd   密码
 */
-(void)Login:(NSString *)mobel andpwd:(NSString *)pwd
{
    DataProvider *dataprovider=[[DataProvider alloc] init];
    [dataprovider Login:mobel andpwd:pwd];
}
/**
 *  重置密码
 *
 *  @param prm <#prm description#>
 */
-(void)ResetPwd:(id)prm
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider ResetPwd:prm];
}
-(void)ChangeUserName:(NSString *)username andkey:(NSString *)key
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider ChangeUserName:username andkey:key];
}

-(void)UpLoadImage:(NSString *)imagePath andkey:(NSString *)key
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider UpLoadImage:imagePath andkey:key];
}
-(void)SaveAvatarWithAvatarName:(NSString *)avatarname andkey:(NSString *)key
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider SaveAvatarWithAvatarName:avatarname andkey:key];
}
/**
 *  签到
 *
 *  @param key <#key description#>
 */
-(void)signIn:(NSString *)key
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider signIn:key];
}

-(void)GetProList:(NSString *)key
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider GetProList:key];
}
-(void)GetAddressList:(NSString *)key
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider GetAddressList:key];
}

-(void)GetArrayListwithareaid:(NSString *)area_id andkey:(NSString *)key
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider GetArrayListwithareaid:area_id andkey:key];
}

-(void)addAddress:(id)prm
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider addAddress:prm];
}

-(void)SetDefaultAddressWithaddressid:(NSString *)address_id andkey:(NSString *)key
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider SetDefaultAddressWithaddressid:address_id andkey:key];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
