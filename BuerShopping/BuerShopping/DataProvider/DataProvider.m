//
//  DataProvider.m
//  BuerShopping
//
//  Created by 于金祥 on 15/5/30.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "DataProvider.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLRequestSerialization.h"
//#import "HttpRequest.h"

#define Url @"http://115.28.21.137/mobile/"

@implementation DataProvider

#pragma mark 赋值回调
- (void)setDelegateObject:(id)cbobject setBackFunctionName:(NSString *)selectorName
{
    CallBackObject = cbobject;
    callBackFunctionName = selectorName;
}
/**
 *  注册
 *
 *  @param prm <#prm description#>
 */
-(void)RegisterUserInfo:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=login&op=register",Url];
        [self PostRequest:url andpram:prm];
    }
}
-(void)Login:(NSString *)mobel andpwd:(NSString *)pwd
{
    if (mobel&&pwd) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=login",Url];
        NSDictionary * prm=@{@"mobile":mobel,@"password":pwd,@"client":@"ios"};
        [self PostRequest:url andpram:prm];
    }
}
-(void)ResetPwd:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=login&op=restpasswd",Url];
        [self PostRequest:url andpram:prm];
    }
}
-(void)ChangeUserName:(NSString *)username andkey:(NSString *)key
{
    if (username&&key) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_index&op=editname",Url];
        NSDictionary * prm=@{@"user_name":username,@"key":key};
        [self PostRequest:url andpram:prm];
    }
}

-(void)signIn:(NSString *)key
{
    if (key) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_index&op=signin",Url];
        NSDictionary * prm=@{@"key":key};
        [self PostRequest:url andpram:prm];
    }
}

-(void)UpLoadImage:(NSString *)imagePath andkey:(NSString *)key
{
    if (imagePath&&key) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_index&op=avatar_upload",Url];
        NSDictionary * prm=@{@"key":key,@"name":@"avatar"};
        [self uploadImageWithImage:imagePath andurl:url andprm:prm andkey:key];
    }
}
-(void)SaveAvatarWithAvatarName:(NSString *)avatarname andkey:(NSString *)key
{
    if (avatarname&&key) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_index&op=avatar_save",Url];
        NSDictionary * prm=@{@"key":key,@"avatar":avatarname};
        [self PostRequest:url andpram:prm];
    }
}

-(void)GetProList:(NSString *)key
{
    if (key) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_points&op=goods_list",Url];
        NSDictionary * prm=@{@"key":key};
        [self PostRequest:url andpram:prm];
    }
}

-(void)GetAddressList:(NSString *)key
{
    if (key) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_address&op=address_list",Url];
        NSDictionary * prm=@{@"key":key};
        [self PostRequest:url andpram:prm];
    }

}

-(void)GetArrayListwithareaid:(NSString *)area_id andkey:(NSString *)key
{
    if (key) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_address&op=area_list",Url];
        NSDictionary * prm=@{@"key":key,@"area_id":area_id};
        [self PostRequest:url andpram:prm];
    }
}
-(void)addAddress:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_address&op=address_add",Url];
        [self PostRequest:url andpram:prm];
    }
}
-(void)SetDefaultAddressWithaddressid:(NSString *)address_id andkey:(NSString *)key
{
    if (key&&address_id) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_address&op=address_default",Url];
        NSDictionary * prm=@{@"key":key,@"address_id":address_id};
        [self PostRequest:url andpram:prm];
    }
}

-(void)DelAddressWithAddressid:(NSString *)address_id andkey:(NSString *)key
{
    if (key&&address_id) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_address&op=address_del",Url];
        NSDictionary * prm=@{@"key":key,@"address_id":address_id};
        [self PostRequest:url andpram:prm];
    }
}

-(void)EditAddressWithPrm:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_address&op=address_edit",Url];
        [self PostRequest:url andpram:prm];
    }
}

-(void)DuihuanFunction:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_points&op=exchange",Url];
        [self PostRequest:url andpram:prm];
    }
}

-(void)GetjifenDetial:(NSString *)key
{
    if (key) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_points&op=points_log",Url];
        NSDictionary * prm=@{@"key":key};
        [self PostRequest:url andpram:prm];
    }
}

-(void)GetClassify
{
    NSString * url=[NSString stringWithFormat:@"%@index.php?act=goods_class",Url];
    [self PostRequest:url andpram:nil];
}

-(void)GetClassifyNext:(NSString *)gc_id
{
    NSString * url=[NSString stringWithFormat:@"%@index.php?act=goods_class&gc_id=%@",Url,gc_id];
    [self PostRequest:url andpram:nil];
}

-(void)GetcityInfoWithlng:(NSString *)lng andlat:(NSString *)lat
{
    if (lng&&lat) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=area&op=location",Url];
        NSDictionary * prm=@{@"lng":lng,@"lat":lat};
        [self GetRequest:url andpram:prm];
    }
}

-(void)GetIndexDataWithAreaid:(NSString *)areaid andlng:(NSString *)lng andlat:(NSString *)lat
{
    if (areaid&&lng&&lat) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=index",Url];
        NSDictionary * prm=@{@"lng":lng,@"lat":lat,@"city_id":areaid};
        [self GetRequest:url andpram:prm];
    }
}

-(void)GetGoodsListWithKeyWord:(NSDictionary *)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=goods&op=goods_list",Url];
        [self GetRequest:url andpram:prm];
    }
}

-(void)getClassifyForStore
{
    NSString * url=[NSString stringWithFormat:@"%@index.php?act=store&op=store_class",Url];
    [self GetRequest:url andpram:nil];
}

-(void)GetStoreList:(NSDictionary *)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=store&op=store_list",Url];
        [self GetRequest:url andpram:prm];
    }
}

-(void)GetStoreDetialInfoWithKey:(NSString *)key andstoreid:(NSString *)store_id
{
    if (key&&store_id) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=store&op=store_info",Url];
        NSDictionary * prm=@{@"key":key,@"store_id":store_id};
        [self GetRequest:url andpram:prm];
    }
}

-(void)GetStoreGoodList:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=store&op=store_goods",Url];
        [self GetRequest:url andpram:prm];
    }
}

-(void)PostRequest:(NSString *)url andpram:(NSDictionary *)pram
{
    AFHTTPRequestOperationManager * manage=[[AFHTTPRequestOperationManager alloc] init];
    manage.responseSerializer=[AFHTTPResponseSerializer serializer];
    manage.requestSerializer=[AFHTTPRequestSerializer serializer];
    manage.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];//可接收到的数据类型
    manage.requestSerializer.timeoutInterval=10;//设置请求时限
    NSDictionary * prm =[[NSDictionary alloc] init];
    if (pram!=nil) {
        prm=pram;
    }
    [manage POST:url parameters:prm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSDictionary * dict =responseObject;
        NSString *str=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * data =[str dataUsingEncoding:NSUTF8StringEncoding];
        id dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        SEL func_selector = NSSelectorFromString(callBackFunctionName);
        if ([CallBackObject respondsToSelector:func_selector]) {
            NSLog(@"回调成功...");
            [CallBackObject performSelector:func_selector withObject:dict];
        }else{
            NSLog(@"回调失败...");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
        [SVProgressHUD dismiss];
    }];
}



-(void)GetRequest:(NSString *)url andpram:(NSDictionary *)pram
{
    AFHTTPRequestOperationManager * manage=[[AFHTTPRequestOperationManager alloc] init];
    manage.responseSerializer=[AFHTTPResponseSerializer serializer];
    manage.requestSerializer=[AFHTTPRequestSerializer serializer];
    manage.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];//可接收到的数据类型
    manage.requestSerializer.timeoutInterval=10;//设置请求时限
    NSDictionary * prm =[[NSDictionary alloc] init];
    if (pram!=nil) {
        prm=pram;
    }
    [manage GET:url parameters:prm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * data =[str dataUsingEncoding:NSUTF8StringEncoding];
        id dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        SEL func_selector = NSSelectorFromString(callBackFunctionName);
        if ([CallBackObject respondsToSelector:func_selector]) {
            NSLog(@"回调成功...");
            [CallBackObject performSelector:func_selector withObject:dict];
        }else{
            NSLog(@"回调失败...");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
}

- (void)uploadImageWithImage:(NSString *)imagePath andurl:(NSString *)url andprm:(NSDictionary *)prm andkey:(NSString *)key
{
    NSData *data=[NSData dataWithContentsOfFile:imagePath];
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:prm constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"avatar" fileName:@"avatar.jpg" mimeType:@"image/jpg"];
    }];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * data =[str dataUsingEncoding:NSUTF8StringEncoding];
        id dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        SEL func_selector = NSSelectorFromString(callBackFunctionName);
        if ([CallBackObject respondsToSelector:func_selector]) {
            NSLog(@"回调成功...");
            [CallBackObject performSelector:func_selector withObject:dict];
        }else{
            NSLog(@"回调失败...");
        }
        NSLog(@"上传完成");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传失败->%@", error);
        [SVProgressHUD dismiss];
    }];
    
    //执行
    NSOperationQueue * queue =[[NSOperationQueue alloc] init];
    [queue addOperation:op];
//    FileDetail *file = [FileDetail fileWithName:@"avatar.jpg" data:data];
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
//                            file,@"FILES",
//                            @"avatar",@"name",
//                            key, @"key", nil];
//    NSDictionary *result = [HttpRequest upload:[NSString stringWithFormat:@"%@index.php?act=member_index&op=avatar_upload",Url] widthParams:params];
//    NSLog(@"%@",result);
}



@end
