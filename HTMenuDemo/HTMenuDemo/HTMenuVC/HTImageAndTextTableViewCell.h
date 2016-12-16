//
//  HTImageAndTextTableViewCell.h
//  HTUIDemo
//
//  Created by cxq on 16/4/6.
//  Copyright © 2016年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTImageAndTextTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel  *itemLabel;
@property (nonatomic, strong) UIImageView  *itemImageView;
@property (nonatomic, strong) NSString *itemText;
@property (nonatomic, strong) UIImage  *itemImage;
@property (nonatomic, strong) UIView *line;
@end
