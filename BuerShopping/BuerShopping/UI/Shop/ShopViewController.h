//
//  ShopViewController.h
//  BuerShopping
//
//  Created by 于金祥 on 15/5/30.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
#import "DOPDropDownMenu.h"

@interface ShopViewController : BaseNavigationController<DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSString * keyWord;
@property(nonatomic,strong)NSString * sc_id;
@property (weak, nonatomic) IBOutlet UITableView *myTableview;

@end
