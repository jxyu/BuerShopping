//
//  GoodDetialViewController.h
//  BuerShopping
//
//  Created by 于金祥 on 15/7/2.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface GoodDetialViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSString * gc_id;
@property (weak, nonatomic) IBOutlet UIView *backviw_bottom;

@end
