//
//  RegisterViewController.h
//  BuerShopping
//
//  Created by 于金祥 on 15/6/1.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface RegisterViewController : BaseNavigationController
@property (weak, nonatomic) IBOutlet UIView *FirstView;
@property (weak, nonatomic) IBOutlet UIView *VerifyBackView;
@property (weak, nonatomic) IBOutlet UIButton *GetVerifyCode;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIButton *Submit;
@property (weak, nonatomic) IBOutlet UITextField *txt_PhoneNo;
@property (weak, nonatomic) IBOutlet UITextField *txt_VerifyCode;
@property (weak, nonatomic) IBOutlet UITextField *txt_pwd;

@end
