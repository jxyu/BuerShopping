//
//  PinglunViewController.h
//  BuerShopping
//
//  Created by 于金祥 on 15/7/6.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface PinglunViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *_myTableview;
@property(nonatomic,strong)NSString * good_id;
@property(nonatomic,strong)NSString * num_pinglun;

@end
