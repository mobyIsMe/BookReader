//
//  ReadCollectionCell.h
//  UICollectionVIewDemo
//
//  Created by HD on 16/7/12.
//  Copyright © 2016年 hongli. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BookModel;

@interface ReadCollectionCell : UICollectionViewCell
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *bookNameLabel;
@property(nonatomic,strong)UILabel *txtBookName;
@property(nonatomic,strong)UILabel *txtSign;
@property(nonatomic,strong)UIButton* deleteBtn;
- (void)configBookCellModel:(BookModel *)model;

@end
