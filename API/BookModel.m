//
//  BookModel.m
//  UICollectionVIewDemo
//
//  Created by HD on 16/7/12.
//  Copyright © 2016年 hongli. All rights reserved.
//

#import "BookModel.h"
#import "LSYReadUtilites.h"
@implementation BookModel

-(id)initWithDict:(NSDictionary*) dict{
    self.bookID  = [dict valueForKey:@"id" ];
    self.bookName = [dict valueForKey:@"name" ];
    self.authorName = [dict valueForKey:@"author"];
    //NSNumber* num = [dict valueForKey:@"size"];
    self.bookSize = [dict valueForKey:@"size"];
    self.isSelected = NO;
    //书籍下载的链接
    //self.downloadURL = [dict valueForKey:@"url" ];
//      self.downloadURL = @"https://manuals.info.apple.com/MANUALS/1000/MA1595/en_US/ipad_user_guide.pdf";
//    self.downloadURL = @"https://github.com/mobyzhang/BookReader/blob/master/LSYReader/files/%E7%BB%86%E8%AF%B4%E6%98%8E%E6%9C%9D.epub";
    self.downloadURL =@"http://o8wiem8yd.bkt.clouddn.com/22378.txt";
    NSString* bookExtension =[[self.downloadURL lastPathComponent]pathExtension];
    if([bookExtension isEqualToString:@"txt"]){
        self.bookType = BookTypeTXT;
    
    }else if([bookExtension isEqualToString:@"pdf"]){
        self.bookType = BookTypePDF;
    }//默认是epub
    
    if([[LSYReadUtilites getBookIDDone] containsString:self.bookName]){
        self.downloadState = @"done";
    }else if ([[LSYReadUtilites getBookIDContinue] containsString:self.bookName]){
        self.downloadState = @"continue";
    }else {
        self.downloadState = @"start";

    }
    return self;
}

@end
