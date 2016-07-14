//
//  ZPDFView.h
//  pdfReader
//
//  Created by XuJackie on 15/6/6.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import <UIKit/UIKit.h>
/////是一样吗？

@interface ZPDFView : UIView {
    CGPDFDocumentRef pdfDocument;
    int pageNO;
}

-(id)initWithFrame:(CGRect)frame atPage:(int)index withPDFDoc:(CGPDFDocumentRef) pdfDoc;

@end
