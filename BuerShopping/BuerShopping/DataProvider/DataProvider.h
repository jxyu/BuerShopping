//
//  DataProvider.h
//  BuerShopping
//
//  Created by 于金祥 on 15/5/30.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataProvider : NSObject
{
    id CallBackObject;
    NSString * callBackFunctionName;
}
/**
 *  注册
 *
 *  @param prm 参数
 */
-(void)RegisterUserInfo:(id)prm;
/**
 *  登录
 *
 *  @param mobel 手机号
 *  @param pwd   密码
 */
-(void)Login:(NSString *)mobel andpwd:(NSString *)pwd;
/**
 *  重置密码
 *
 *  @param prm <#prm description#>
 */
-(void)ResetPwd:(id)prm;
/**
 *  修改昵称
 *
 *  @param username 昵称
 *  @param key      登录令牌
 */
-(void)ChangeUserName:(NSString *)username andkey:(NSString *)key;
/**
 *  上传头像
 *
 *  @param imagePath 图片在沙盒的路径
 */
-(void)UpLoadImage:(NSString *)imagePath andkey:(NSString *)key;
/**
 *  保存头像
 *
 *  @param avatarname 上传成功后返回的
 *  @param key        key
 */
-(void)SaveAvatarWithAvatarName:(NSString *)avatarname andkey:(NSString *)key;
/**
 *  签到
 *
 *  @param key key
 */
-(void)signIn:(NSString *)key;
/**
 *  获得兑换奖品
 *
 *  @param key key
 */
-(void)GetProList:(NSString *)key;
/**
 *  获取收货地址列表
 *
 *  @param key key
 */
-(void)GetAddressList:(NSString *)key;
/**
 *  获取地区列表
 *
 *  @param area_id areaid获取第一级列表传空即可
 *  @param key     key
 */
-(void)GetArrayListwithareaid:(NSString *)area_id andkey:(NSString *)key;
/**
 *  添加收货地址
 *
 *  @param prm <#prm description#>
 */
-(void)addAddress:(id)prm;
/**
 *  设置默认收货地址
 *
 *  @param address_id 收货地址的id
 *  @param key        key
 */
-(void)SetDefaultAddressWithaddressid:(NSString *)address_id andkey:(NSString *)key;


/**
 *  设置回调函数
 *
 *  @param cbobject     回调对象
 *  @param selectorName 回调函数
 */
- (void)setDelegateObject:(id)cbobject setBackFunctionName:(NSString *)selectorName;

@end
