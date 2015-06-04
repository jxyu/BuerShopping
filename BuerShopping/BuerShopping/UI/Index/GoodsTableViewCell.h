//
//  GoodsTableViewCell.h
//  BuerShopping
//
//  Created by 于金祥 on 15/6/3.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img_goodsicon;
@property (weak, nonatomic) IBOutlet UILabel *lbl_goodsName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_long;
@property (weak, nonatomic) IBOutlet UILabel *lbl_goodsDetial;
@property (weak, nonatomic) IBOutlet UILabel *lbl_price;
- (IBAction)MoreClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *BackView_more;
@property (weak, nonatomic) IBOutlet UILabel *lbl_rescuncun;
@property (weak, nonatomic) IBOutlet UILabel *lbl_resxiaoliang;
@property (weak, nonatomic) IBOutlet UILabel *lbl_liulanliang;

@end
