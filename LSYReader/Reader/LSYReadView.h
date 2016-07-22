//
//  LSYReadView.h
//  LSYReader
//
//  Created by Labanotation on 16/5/30.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LSYReadViewControllerDelegate;
@interface LSYReadView : UIView{
    
    }
@property Boolean isPDF;
@property CGPDFDocumentRef pdfDocument;
@property int pageNO;

@property (nonatomic,assign) CTFrameRef frameRef;
@property (nonatomic,strong) NSString *content;


@property (nonatomic,strong) id<LSYReadViewControllerDelegate>delegate;
-(void)cancelSelected;
-(id)initWithFrame:(CGRect)frame atPage:(int)index withPDFDoc:(CGPDFDocumentRef) pdfDoc;
@end
