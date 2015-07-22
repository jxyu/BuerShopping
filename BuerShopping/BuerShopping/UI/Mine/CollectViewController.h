//
//  CollectViewController.h
//  BuerShopping
//
//  Created by 于金祥 on 15/7/21.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface CollectViewController : BaseNavigationController
@property(nonatomic,strong) NSString *  key;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end
