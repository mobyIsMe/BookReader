//
//  BookModel.m
//  UICollectionVIewDemo
//
//  Created by HD on 16/7/12.
//  Copyright © 2016年 hongli. All rights reserved.
//

#import "BookModel.h"

@implementation BookModel
-(id)initWithDict:(NSDictionary*) dict{
    self.bookName = [dict valueForKey:@"name" ];
    self.authorName = [dict valueForKey:@"author"];
    //NSNumber* num = [dict valueForKey:@"size"];
    self.bookSize = [dict valueForKey:@"size"];
    self.isSelected = NO;
    return self;
}

@end
