//
//  IndexViewController.m
//  BuerShopping
//
//  Created by 于金祥 on 15/5/30.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "IndexViewController.h"
#import "CommenDef.h"
#import "AppDelegate.h"

@interface IndexViewController ()

@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _ScrollView_backView.contentSize=CGSizeMake(SCREEN_WIDTH, 1000);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end