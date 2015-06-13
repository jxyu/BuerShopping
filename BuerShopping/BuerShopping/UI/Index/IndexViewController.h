//
//  IndexViewController.h
//  BuerShopping
//
//  Created by 于金祥 on 15/5/30.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
#import "SDCycleScrollView.h"
#import "UIImageView+WebCache.h"
#import "CycleScrollView.h"

@interface IndexViewController : BaseNavigationController <UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *TableView_BackView;


@end
