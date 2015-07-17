//
//  CarCellNormalTableViewCell.h
//  BuerShopping
//
//  Created by 于金祥 on 15/7/10.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarCellNormalTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btn_cellselect;
@property (weak, nonatomic) IBOutlet UIImageView *img_GoodLogo;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_detial;
@property (weak, nonatomic) IBOutlet UILabel *lbl_price;
@property (weak, nonatomic) IBOutlet UILabel *lbl_num;

@end
