//
//  HTImageAndTextTableViewCell.m
//  HTUIDemo
//
//  Created by cxq on 16/4/6.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "HTImageAndTextTableViewCell.h"
#import "UIView+Frame.h"

@interface HTImageAndTextTableViewCell ()

@end

@implementation HTImageAndTextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadSubviews];
    }
    return self;
}

- (void)loadSubviews
{
    _itemImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _itemImageView.backgroundColor = [UIColor clearColor];
    _itemLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _itemLabel.textAlignment = NSTextAlignmentLeft;
    _itemLabel.backgroundColor = [UIColor clearColor];
    _itemLabel.textColor = [UIColor whiteColor];
    
    _line = [[UIView alloc] init];
    _line.backgroundColor = [UIColor whiteColor];
    [self addSubview:_line];
    
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:_itemImageView];
    [self addSubview:_itemLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _itemImageView.middleY = self.height/2;
    _itemImageView.x = 5;
    _itemLabel.middleY = _itemImageView.middleY;
    _itemLabel.x = _itemImageView.tail +10;
    _line.width = self.width;
    _line.height = 1.0/[UIScreen mainScreen].scale;
    _line.bottom = self.height;
}

- (void)setItemText:(NSString *)itemText
{
    if (_itemText != itemText) {
        _itemText = itemText;
        _itemLabel.text = _itemText;
        [_itemLabel sizeToFit];
    }
}

- (void)setItemImage:(UIImage *)itemImage
{
    if (_itemImage != itemImage) {
        _itemImage = itemImage;
        _itemImageView.image = _itemImage;
        [_itemImageView sizeToFit];
    }
}

@end
