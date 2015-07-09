//
//  PurseViewController.h
//  BuerShopping
//
//  Created by 于金祥 on 15/7/9.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface PurseViewController : BaseNavigationController<UIActionSheetDelegate>
@property(nonatomic,strong)NSString * key;
@property (weak, nonatomic) IBOutlet UILabel *lbl_money;
@property (weak, nonatomic) IBOutlet UITextField *txt_money;
@property (weak, nonatomic) IBOutlet UIButton *btn_chongzhi;

@end
