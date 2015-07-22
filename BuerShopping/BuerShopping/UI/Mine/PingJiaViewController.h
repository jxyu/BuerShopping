//
//  PingJiaViewController.h
//  BuerShopping
//
//  Created by 于金祥 on 15/7/22.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface PingJiaViewController : BaseNavigationController

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) NSDictionary * orderData;
@property (nonatomic,strong) NSString * key;
- (IBAction)submitClick:(UIButton *)sender;


@end
