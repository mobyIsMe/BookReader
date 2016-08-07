//
//  BookModel.h
//  UICollectionVIewDemo
//
//  Created by HD on 16/7/12.
//  Copyright © 2016年 hongli. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BookType) {
    BookTypeEPUB,
    BookTypePDF,
    BookTypeTXT
};

@interface BookModel : NSObject

@property(nonatomic,copy) NSString *cover;
@property(nonatomic,copy) NSString *bookName;
@property(nonatomic,copy) NSString *filePath;
@property(nonatomic,assign) BookType bookType;
@property(nonatomic,copy) NSString *authorName;
@property(nonatomic,copy) NSNumber* bookSize;
@property(nonatomic,copy) NSString* bookID;
@property(nonatomic,copy) NSString* downloadURL;
@property Boolean isSelected;
@property(nonatomic,copy)NSString* downloadState;//start, continue,done,代表下载的3种状态
-(id)initWithDict:(NSDictionary*) dict;
@end
