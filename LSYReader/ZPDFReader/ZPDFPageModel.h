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

@interface ZPDFPageModel : NSObject  <UIPageViewControllerDataSource>
{
    CGPDFDocumentRef pdfDocument;
    
}
@property (nonatomic,strong) NSURL *resourceURL;
@property int pageChanged;
@property int chapterChanged;
//@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) id<ZPDFPageModelDelegate>delegate;
@property (nonatomic, strong) NSString* fileName;
@property (nonatomic,strong) LSYReadModel *model;
-(id) initWithPDFDocument:(CGPDFDocumentRef) pdfDocument;

- (ZPDFPageController *)viewControllerAtIndex:(NSUInteger)index withChapterNO:(NSUInteger)chapterNO;
- (NSUInteger)indexOfViewController:(ZPDFPageController *)viewController;

@end
