//
//  DuihuanDetialViewController.h
//  BuerShopping
//
//  Created by 于金祥 on 15/6/16.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface DuihuanDetialViewController : BaseNavigationController<UITextFieldDelegate>
- (IBAction)AddAddressClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *Image_logo;
@property (weak, nonatomic) IBOutlet UILabel *good_title;
@property (weak, nonatomic) IBOutlet UILabel *goodsDetial;
@property (weak, nonatomic) IBOutlet UILabel *goodsjifen;
@property (weak, nonatomic) IBOutlet UITextField *txt_message;
@property (weak, nonatomic) IBOutlet UIView *addaddressBackView;

@property (weak, nonatomic) IBOutlet UIButton *btn_duihuan;
@property(nonatomic,strong)NSDictionary *goods_dict;
@property(nonatomic,strong)NSString * userkey;

@end
