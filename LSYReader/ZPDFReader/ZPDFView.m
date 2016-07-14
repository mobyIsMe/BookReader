//
//  ZPDFView.m
//  pdfReader
//
//  Created by XuJackie on 15/6/6.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import "ZPDFView.h"

@implementation ZPDFView

-(id)initWithFrame:(CGRect)frame atPage:(int)index withPDFDoc:(CGPDFDocumentRef) pdfDoc{
    self = [super initWithFrame:frame];
    if(self){
        pageNO = index;
        pdfDocument = pdfDoc;
    }
    return self;
}

-(void)drawInContext:(CGContextRef)context atPageNo:(int)page_no{
    // PDF page drawing expects a Lower-Left coordinate system, so we flip the coordinate system
    // before we start drawing.
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    if (pageNO == 0) {
        pageNO = 1;
    }
    
    CGPDFPageRef page = CGPDFDocumentGetPage(pdfDocument, pageNO);
    CGContextSaveGState(context);
    {
        CGRect rect = CGRectInset(self.bounds, -50, -95);
        CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFCropBox, rect, 0, true);
        CGContextConcatCTM(context, pdfTransform);
        CGContextDrawPDFPage(context, page);
    }
    CGContextRestoreGState(context);
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    //画页码
    CGContextSaveGState(context);
    {
        CGContextSetLineWidth(context, 1.0);
        CGContextSetRGBFillColor (context,  1, 1, 1, 1.0);
        long pageSum = CGPDFDocumentGetNumberOfPages(pdfDocument);
        NSString *pageStr=[NSString stringWithFormat:@"第%d页，共%ld页",pageNO,pageSum];
        CGRect rect1=CGRectMake(0, self.bounds.size.height -30, self.bounds.size.width, 20);
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSDictionary *attributes=@{
                                   NSFontAttributeName:[UIFont systemFontOfSize:14],
                                   NSParagraphStyleAttributeName : paragraphStyle,
                                   NSForegroundColorAttributeName: [UIColor colorWithWhite:.6 alpha:.6]
                                   };
        [pageStr drawInRect:rect1 withAttributes:attributes];
    }
    CGContextRestoreGState(context);
    
    //画PDF内容
    [self drawInContext:context atPageNo:pageNO];
}

@end
