//
//  OrderForSureViewController.h
//  BuerShopping
//
//  Created by 于金祥 on 15/7/14.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface OrderForSureViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UITextFieldDelegate>
- (IBAction)payForOrder:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbl_price;
@property (weak, nonatomic) IBOutlet UITableView *mytableview;
@property(nonatomic,strong) NSDictionary *OrderData;
@property(nonatomic,strong)NSString *key;
@end
