//
//  BookStoreTableViewCell.m
//  LSYReader
//
//  Created by hongli on 16/7/29.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "BookStoreTableViewCell.h"

@implementation BookStoreTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        int frameWidth = CGRectGetWidth(self.frame);
        int frameHeight = CGRectGetHeight(self.frame);
        _bookTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, frameHeight/2, frameWidth/3, frameHeight/2)];
        _authorName = [[UILabel alloc]initWithFrame:CGRectMake(_bookTitle.frame.size.width+20, frameHeight/2, frameWidth/3, frameHeight/2)];
       _downloadBtn = [[UIButton alloc]initWithFrame:CGRectMake(_bookTitle.frame.size.width+_authorName.frame.size.width+30, frameHeight/2, frameWidth/3, frameHeight/2)];
        [_bookTitle setText:@"书名"];
        [_authorName setText:@"作者名"];
        [_downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
        [_downloadBtn setBackgroundColor:[UIColor grayColor]];
        [self addSubview:_bookTitle];
        [self addSubview:_authorName];
        [self addSubview:_downloadBtn];
    }
    return self;
}

@end
