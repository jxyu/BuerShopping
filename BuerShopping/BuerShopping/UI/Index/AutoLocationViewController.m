//
//  AutoLocationViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/7/7.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "AutoLocationViewController.h"

@interface AutoLocationViewController ()

@end

@implementation AutoLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"Icon_Back@2x.png"];
    _lblTitle.text=@"";
    _lblTitle.textColor=[UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
