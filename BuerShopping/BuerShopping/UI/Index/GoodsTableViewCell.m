//
//  GoodsTableViewCell.m
//  BuerShopping
//
//  Created by 于金祥 on 15/6/3.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "GoodsTableViewCell.h"

@implementation GoodsTableViewCell
{
    BOOL backView_moreisShow;
}

- (void)awakeFromNib {
    // Initialization code
    backView_moreisShow=NO;
    _BackView_more.hidden=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)MoreClick:(UIButton *)sender {
    if (backView_moreisShow) {
        _BackView_more.hidden=YES;
    }
    else
    {
        _BackView_more.hidden=NO;
    }
    
}
@end
