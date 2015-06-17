//
//  JiFenCellTableViewCell.h
//  BuerShopping
//
//  Created by 于金祥 on 15/6/15.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JiFenCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *lipin_logo;
@property (weak, nonatomic) IBOutlet UILabel *lipin_title;
@property (weak, nonatomic) IBOutlet UILabel *lipin_lipindetial;
@property (weak, nonatomic) IBOutlet UILabel *lipin_jifen;
@property (weak, nonatomic) IBOutlet UIButton *Btn_duihuan;

@end
