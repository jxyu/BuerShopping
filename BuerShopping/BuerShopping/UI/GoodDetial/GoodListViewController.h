//
//  GoodListViewController.h
//  BuerShopping
//
//  Created by 于金祥 on 15/6/30.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface GoodListViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSString *KeyWord;
@property(nonatomic,strong)NSString *gc_id;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end
