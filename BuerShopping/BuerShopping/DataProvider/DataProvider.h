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
 *  删除地址
 *
 *  @param address_id <#address_id description#>
 *  @param key        <#key description#>
 */
-(void)DelAddressWithAddressid:(NSString *)address_id andkey:(NSString *)key;
/**
 *  修改地址
 *
 *  @param prm <#prm description#>
 */
-(void)EditAddressWithPrm:(id)prm;
/**
 *  积分兑换
 *
 *  @param prm <#prm description#>
 */
-(void)DuihuanFunction:(id)prm;
/**
 *  获取积分详情
 *
 *  @param key <#key description#>
 */
-(void)GetjifenDetial:(NSString *)key;

/**
 *  获取商品分类
 */
-(void)GetClassify;
/**
 *  获取商品下一级分类
 *
 *  @param gc_id 分类id
 */
-(void)GetClassifyNext:(NSString *)gc_id;
/**
 *  根据经纬度获取城市信息
 *
 *  @param lng <#lng description#>
 *  @param lat <#lat description#>
 */
-(void)GetcityInfoWithlng:(NSString *)lng andlat:(NSString *)lat;
/**
 *  获取首页数据
 *
 *  @param areaid 城市ID
 *  @param lng    <#lng description#>
 *  @param lat    <#lat description#>
 */
-(void)GetIndexDataWithAreaid:(NSString *)areaid andlng:(NSString *)lng andlat:(NSString *)lat;
/**
 *  获取商品列表
 *
 *  @param prm 参数字典
 */
-(void)GetGoodsListWithKeyWord:(NSDictionary *)prm;
/**
 *  获取店铺分类
 */
-(void)getClassifyForStore;
/**
 *  获取店铺列表
 *
 *  @param prm 参数字典
 */
-(void)GetStoreList:(NSDictionary *)prm;
/**
 *  获取店铺详情
 *
 *  @param key      用户登录的key
 *  @param store_id 店铺ID
 */
-(void)GetStoreDetialInfoWithKey:(NSString *)key andstoreid:(NSString *)store_id;
/**
 *  获取店铺商品列表
 *
 *  @param prm <#prm description#>
 */
-(void)GetStoreGoodList:(id)prm;
/**
 *  获取商品详情
 *
 *  @param goodid 商品id
 */
-(void)GetGoodDetialInfoWithid:(NSString *)goodid;
/**
 *  获取更多评论
 *
 *  @param goodid <#goodid description#>
 */
-(void)GetMorePinglun:(NSString *)goodid;
/**
 *  获取城市列表
 */
-(void)GetCityList;




/**
 *  设置回调函数
 *
 *  @param cbobject     回调对象
 *  @param selectorName 回调函数
 */
- (void)setDelegateObject:(id)cbobject setBackFunctionName:(NSString *)selectorName;

@end
