//
//  SendShowOrderViewController.h
//  BuerShopping
//
//  Created by 于金祥 on 15/7/20.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface SendShowOrderViewController : BaseNavigationController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *txt_text;
@property (weak, nonatomic) IBOutlet UILabel *lbl_placeholder;
@property (weak, nonatomic) IBOutlet UILabel *lbl_xing;
@property (nonatomic,strong)NSString * key;
@end
