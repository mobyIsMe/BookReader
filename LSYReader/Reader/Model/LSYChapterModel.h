//
//  LSYChapterModel.h
//  LSYReader
//
//  Created by Labanotation on 16/5/31.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface LSYChapterModel : NSObject<NSCopying,NSCoding>
@property (nonatomic,strong) NSString *content;//目录
@property (nonatomic,strong) NSString *title;//标题：chapter1
@property (nonatomic) NSUInteger pageCount;//页码
-(NSString *)stringOfPage:(NSUInteger)index;
-(void)updateFont;
+(id)chapterWithEpub:(NSString *)chapterpath title:(NSString *)title;
+(id)chapterWithPdf:(NSString *)chapterTitle WithPageCount:(NSUInteger)pageNum;
@end
