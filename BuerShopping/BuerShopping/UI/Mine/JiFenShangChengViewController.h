//
//  JiFenShangChengViewController.h
//  BuerShopping
//
//  Created by 于金祥 on 15/6/15.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface JiFenShangChengViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)NSString *userkey;

@end
