//
//  LSYReadModel.h
//  LSYReader
//
//  Created by Labanotation on 16/5/31.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSYMarkModel.h"
#import "LSYNoteModel.h"
#import "LSYChapterModel.h"
#import "LSYRecordModel.h"
@interface LSYReadModel : NSObject<NSCoding>
@property (nonatomic,strong) NSURL *resource;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,strong) NSMutableArray <LSYMarkModel *>*marks;
@property (nonatomic,strong) NSMutableArray <LSYNoteModel *>*notes;
@property (nonatomic,strong) NSMutableArray <LSYChapterModel *>*chapters;
@property (nonatomic,strong) LSYRecordModel *record;
//初始化TXT文件
-(instancetype)initWithContent:(NSString *)content;
//初始化epub文件
-(instancetype)initWithePub:(NSString *)ePubPath;
//初始化PDF文件
-(instancetype)initWithPDF:(NSString*)pdfPath;

+(void)updateLocalModel:(LSYReadModel *)readModel url:(NSURL *)url;
+(id)getLocalModelWithURL:(NSURL *)url;
@end
