//
//  LSYReadUtilites.h
//  LSYReader
//
//  Created by Labanotation on 16/5/31.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSString* bookIDDones;
static NSString* bookIDContinues;

@interface LSYReadUtilites : NSObject
+(void)separateChapter:(NSMutableArray **)chapters content:(NSString *)content;
+(NSString *)encodeWithURL:(NSURL *)url;
+(UIButton *)commonButtonSEL:(SEL)sel target:(id)target;
+(UIViewController *)getCurrentVC;
+(void)showAlertTitle:(NSString *)title content:(NSString *)string;
+(NSString*)getBookIDDone;
+(NSString*)getBookIDContinue;
+(void)deleteFileWithFilePath:(NSString*)filePath ;
/**
 * ePub格式处理
 * 返回章节信息数组
 */
+(NSMutableArray *)ePubFileHandle:(NSString *)path;
+(CGPDFDocumentRef)pdfRefByFilePath:(NSString *)aFilePath;
@end
