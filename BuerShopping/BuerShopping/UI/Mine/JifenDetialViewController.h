//
//  JifenDetialViewController.h
//  BuerShopping
//
//  Created by 于金祥 on 15/6/18.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface JifenDetialViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSString * userkey;
@end
