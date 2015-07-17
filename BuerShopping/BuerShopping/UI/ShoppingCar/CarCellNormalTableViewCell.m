//
//  CarCellNormalTableViewCell.m
//  BuerShopping
//
//  Created by 于金祥 on 15/7/10.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "CarCellNormalTableViewCell.h"

@implementation CarCellNormalTableViewCell

- (void)awakeFromNib {
    // Initialization code
    NSLog(@"加载cell");
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, SCREEN_WIDTH, self.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
