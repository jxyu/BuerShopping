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
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySetting.h"
#import <AMapNaviKit/AMapNaviKit.h>

#define appKey @"7bf8c19274e0"
#define appSecret @"a9544d5cdd5854a62ba4f5978be3ef6f"
#define APIKey @"d57667019f79800b1cac4d682465f035";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (void)configureAPIKey
{
    [AMapNaviServices sharedServices].apiKey = (NSString *)APIKey;
    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
}


- (void)configIFlySpeech
{
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,timeout=%@",@"53c35b10",@"20000"];
    
    [IFlySpeechUtility createUtility:initString];
    
    [IFlySetting setLogFile:LVL_NONE];
    [IFlySetting showLogcat:NO];
    
    // 设置语音合成的参数
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];//合成的语速,取值范围 0~100
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"50" forKey:[IFlySpeechConstant VOLUME]];//合成的音量;取值范围 0~100
    
    // 发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表;
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"xiaoyan" forKey:[IFlySpeechConstant VOICE_NAME]];
    
    // 音频采样率,目前支持的采样率有 16000 和 8000;
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"8000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    // 当你再不需要保存音频时，请在必要的地方加上这行。
    [[IFlySpeechSynthesizer sharedInstance] setParameter:nil forKey:[IFlySpeechConstant TTS_AUDIO_PATH]];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self configureAPIKey];
    
    [self configIFlySpeech];
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
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]) {
        self.window.rootViewController =_tabBarViewCol;
    }
    else
    {
        self.window.rootViewController =firstCol;
    }
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
- (void)selectTableBarIndex:(NSInteger)index
{
    [_tabBarViewCol selectTableBarIndex:index];
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

-(void)DelAddressWithAddressid:(NSString *)address_id andkey:(NSString *)key
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider DelAddressWithAddressid:address_id andkey:key];
}

-(void)EditAddressWithPrm:(id)prm
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider EditAddressWithPrm:prm];
}

-(void)DuihuanFunction:(id)prm
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider DuihuanFunction:prm];
}

-(void)GetjifenDetial:(NSString *)key
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider GetjifenDetial:key];
}

-(void)GetClassify
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider GetClassify];
}

-(void)GetClassifyNext:(NSString *)gc_id
{
    DataProvider * dataprovider=[DataProvider alloc];
    [dataprovider GetClassifyNext:gc_id];
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
