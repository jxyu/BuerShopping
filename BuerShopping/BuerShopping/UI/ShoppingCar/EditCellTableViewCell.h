//
//  EditCellTableViewCell.h
//  BuerShopping
//
//  Created by 于金祥 on 15/7/11.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btn_del;
@property (weak, nonatomic) IBOutlet UIButton *btn_add;
@property (weak, nonatomic) IBOutlet UIButton *btn_jian;
@property (weak, nonatomic) IBOutlet UILabel *lbl_num;
@property (weak, nonatomic) IBOutlet UILabel *lbl_detial;
@property (weak, nonatomic) IBOutlet UIImageView *img_logo;
@property (weak, nonatomic) IBOutlet UIButton *btn_select;

@end
