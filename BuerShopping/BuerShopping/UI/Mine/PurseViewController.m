//
//  PurseViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/7/9.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "PurseViewController.h"
#import "DataProvider.h"
#import "AppDelegate.h"
#import "Pingpp.h"

@interface PurseViewController ()

@end

@implementation PurseViewController
{
    BOOL keyboardZhezhaoShow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    keyboardZhezhaoShow=NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(PursekeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    _lblTitle.text=@"我的钱包";
    _lblTitle.textColor=[UIColor whiteColor];
    [self addLeftButton:@"Icon_Back@2x.png"];
    _btn_chongzhi.layer.masksToBounds=YES;
    _btn_chongzhi.layer.cornerRadius=5;
    [_btn_chongzhi addTarget:self action:@selector(btn_chongzhiClick:) forControlEvents:UIControlEventTouchUpInside];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetPurseBackCall:"];
    [dataprovider GetPurseInfo:_key];
}
-(void)GetPurseBackCall:(id)dict
{
    NSLog(@"%@",dict);
    _lbl_money.text=[NSString stringWithFormat:@"%@元",dict[@"datas"][@"predeposit"]];
}
-(void)btn_chongzhiClick:(UIButton * )sender
{
    if (_txt_money.text.length>0) {
        UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"支付宝充值", @"微信充值", nil];
        [choiceSheet showInView:self.view];
    }else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"通知" message:@"请先输入充值金额" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",(long)buttonIndex);
    NSString *payWay=@"";
    if (buttonIndex==0) {
        payWay=@"alipay";
    }else
    {
        payWay=@"wx";
    }
    if (_txt_money.text) {
        NSDictionary * prm=@{@"key":_key,@"pdramount":_txt_money.text,@"channel":payWay};
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"GetChargeBackCall:"];
        [dataprovider GetChargeObject:prm];
    }
    
}
-(void)GetChargeBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if (!dict[@"datas"][@"error"]) {
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString* str_data = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [Pingpp createPayment:str_data
               viewController:self
                 appURLScheme:@"BuerShopping.zykj"
               withCompletion:^(NSString *result, PingppError *error) {
                   if ([result isEqualToString:@"success"]) {
                       // 支付成功
                   } else {
                       // 支付失败或取消
                       NSLog(@"Error: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
                   }
               }];
    }
    
}


//当键盘出现或改变时调用
- (void)PursekeyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    if (!keyboardZhezhaoShow) {
        UIButton * btn_zhezhao=[[UIButton alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, SCREEN_HEIGHT-65-height)];
        [btn_zhezhao addTarget:self action:@selector(Pursebtn_zhezhaoClick:) forControlEvents:UIControlEventTouchUpInside];
        btn_zhezhao.backgroundColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2];
        [self.view addSubview:btn_zhezhao];
        keyboardZhezhaoShow=YES;
    }
}
-(void)Pursebtn_zhezhaoClick:(UIButton *)sender
{
    keyboardZhezhaoShow=NO;
    [_txt_money resignFirstResponder];
    [sender removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

@end
