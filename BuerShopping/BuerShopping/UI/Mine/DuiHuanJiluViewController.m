//
//  DuiHuanJiluViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/6/18.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "DuiHuanJiluViewController.h"
#import "AppDelegate.h"

@interface DuiHuanJiluViewController ()

@end

@implementation DuiHuanJiluViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

@end
