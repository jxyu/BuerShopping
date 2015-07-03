//
//  ResTableViewCell.h
//  BuerShopping
//
//  Created by 于金祥 on 15/6/4.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img_resLogo;
@property (weak, nonatomic) IBOutlet UILabel *lbl_resTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_juli;
@property (weak, nonatomic) IBOutlet UILabel *lbl_pingjia;
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_classify;
@property (weak, nonatomic) IBOutlet UILabel *lbl_resaddress;

@end
