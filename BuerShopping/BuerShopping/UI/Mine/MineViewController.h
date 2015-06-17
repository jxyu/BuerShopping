//
//  MineViewController.h
//  BuerShopping
//
//  Created by 于金祥 on 15/5/30.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "SetViewController.h"
#import "JiFenShangChengViewController.h"

@interface MineViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)RegisterViewController * myRegister;
@property (weak, nonatomic) IBOutlet UITableView *TableView_Mine;
@property(nonatomic,strong)LoginViewController *myLogin;
@property(nonatomic,strong)SetViewController * mySet;
@property(nonatomic,strong)JiFenShangChengViewController * myJifen;
@end
