//
//  ShoppingCarOrderForSureViewController.h
//  BuerShopping
//
//  Created by 于金祥 on 15/7/16.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface ShoppingCarOrderForSureViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mytableview;
- (IBAction)payfororderClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbl_price;
@property(nonatomic,strong)NSString * key;
@property(nonatomic,strong)NSDictionary *OrderData;

@end
