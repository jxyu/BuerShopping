//
//  AddressManageViewController.h
//  BuerShopping
//
//  Created by 于金祥 on 15/6/16.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface AddressManageViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic) BOOL  isfromDuihuan;
@property(nonatomic,strong)NSString * userkey;
@end
