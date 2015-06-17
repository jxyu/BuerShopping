//
//  AddressCellTableViewCell.h
//  BuerShopping
//
//  Created by 于金祥 on 15/6/16.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *address_name;
@property (weak, nonatomic) IBOutlet UILabel *addres_tel;
@property (weak, nonatomic) IBOutlet UILabel *address_addres;
@property (weak, nonatomic) IBOutlet UIImageView *addres_isdefault;
@property (weak, nonatomic) IBOutlet UIButton *Btn_setdefault;

@end
