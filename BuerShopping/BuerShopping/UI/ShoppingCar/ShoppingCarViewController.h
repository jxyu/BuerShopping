//
//  ShoppingCarViewController.h
//  BuerShopping
//
//  Created by 于金祥 on 15/5/30.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface ShoppingCarViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *img_selectAll;
- (IBAction)btn_SelectAllClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbl_price;
@property (weak, nonatomic) IBOutlet UITableView *myTableview;
@property (weak, nonatomic) IBOutlet UIButton *btn_payfororder;

@end
