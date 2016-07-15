//
//  ZPDFView.h
//  pdfReader
//
//  Created by XuJackie on 15/6/6.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPDFView : UIView {
    CGPDFDocumentRef pdfDocument;
    int pageNO;
}
@property (nonatomic, strong) NSArray *items;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,strong) NSMutableArray <LSYMarkModel *>*marks;
@property (nonatomic,strong) NSMutableArray <LSYNoteModel *>*notes;
@property (nonatomic,strong) NSMutableArray <LSYChapterModel *>*chapters;
@property (nonatomic,strong) LSYRecordModel *record;
-(id)initWithFrame:(CGRect)frame atPage:(int)index withPDFDoc:(CGPDFDocumentRef) pdfDoc;
@end
