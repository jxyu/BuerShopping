//
//  IndexViewController.h
//  BuerShopping
//
//  Created by 于金祥 on 15/5/30.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface IndexViewController : BaseNavigationController
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView_backView;
@property (weak, nonatomic) IBOutlet UIView *RoundImage;
@property (weak, nonatomic) IBOutlet UIView *ClassifyView;
@property (weak, nonatomic) IBOutlet UIView *ShowOrderView;
@property (weak, nonatomic) IBOutlet UIView *SprciallOffer;

@end
