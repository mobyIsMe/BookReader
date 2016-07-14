//
//  ZPDFPageModel.h
//  pdfReader
//
//  Created by XuJackie on 15/6/6.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIPageViewController.h>

@protocol ZPDFPageModelDelegate <NSObject>
-(void)pageChanged:(NSInteger)page;
@end

@class ZPDFPageController;

@interface ZPDFPageModel : NSObject <UIPageViewControllerDataSource>
{
    CGPDFDocumentRef pdfDocument;
}

@property (nonatomic, assign) id<ZPDFPageModelDelegate>delegate;

-(id) initWithPDFDocument:(CGPDFDocumentRef) pdfDocument;

- (ZPDFPageController *)viewControllerAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfViewController:(ZPDFPageController *)viewController;

@end
