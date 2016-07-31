//
//  BookStoreTableViewCell.h
//  LSYReader
//
//  Created by hongli on 16/7/29.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookStoreTableViewCell : UITableViewCell
@property(nonatomic,copy)UILabel* bookTitle;
@property(nonatomic,copy)UILabel* authorName ;
@property(nonatomic,copy)UIButton* downloadBtn;

@end
