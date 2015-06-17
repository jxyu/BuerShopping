//
//  AddaddressViewController.h
//  BuerShopping
//
//  Created by 于金祥 on 15/6/16.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface AddaddressViewController : BaseNavigationController<UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSString *userkey;
@property(nonatomic)BOOL isChange;
@property(nonatomic,strong)NSDictionary * data;

@end
