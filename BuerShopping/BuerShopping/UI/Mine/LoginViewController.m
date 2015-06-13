//
//  LoginViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/6/11.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "DataProvider.h"

@interface LoginViewController ()
@property(nonatomic,strong)RegisterViewController *myRegister;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"登录";
    _lblTitle.textColor=[UIColor whiteColor];
    [self addRightbuttontitle:@"注册"];
    [self addLeftButton:@"Icon_Back@2x.png"];
    _BackView_username.translatesAutoresizingMaskIntoConstraints = NO;
    _BackView_username.layer.masksToBounds=YES;
    _BackView_username.layer.cornerRadius=2;
    _BackView_pwd.translatesAutoresizingMaskIntoConstraints = NO;
    _BackView_pwd.layer.masksToBounds=YES;
    _BackView_pwd.layer.cornerRadius=2;
    _Btn_Login.layer.masksToBounds=YES;
    [_Btn_Login addTarget:self action:@selector(LoginFunc) forControlEvents:UIControlEventTouchUpInside];
    _Btn_Login.layer.cornerRadius=3;
    [_Btn_forgetPwd addTarget:self action:@selector(forgetPwd) forControlEvents:UIControlEventTouchUpInside];
}

-(void)LoginFunc
{
    if (_txt_username.text.length==11&&_txt_pwd.text.length>0) {
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"loginBackcall:"];
        [dataprovider Login:_txt_username.text andpwd:_txt_pwd.text];
    }
}
-(void)loginBackcall:(id)dict
{
    NSLog(@"%@",dict);
    NSLog(@"%@",[dict[@"datas"] objectForKey:@"error"]);
    if (![dict[@"datas"] objectForKey:@"error"] ) {
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
        BOOL result= [dict[@"datas"] writeToFile:plistPath atomically:YES];
        if (result) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Login_success" object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}
-(void)forgetPwd
{
    _myRegister=[[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:[NSBundle mainBundle]];
    _myRegister.viewTitle=@"重置密码";
    _myRegister.resetPwd=YES;
    [self.navigationController pushViewController:_myRegister animated:YES];
}
-(void)clickRightButton:(UIButton *)sender
{
    _myRegister=[[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:_myRegister animated:YES];
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
