//
//  ZPDFPageModel.m
//  pdfReader
//
//  Created by XuJackie on 15/6/6.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import "ZPDFPageModel.h"
#import "ZPDFPageController.h"
#import "PDFDocumentOutline.h"
#import "LSYChapterModel.h"
#import "PDFDocumentOutlineItem.h"
#import "LSYReadModel.h"
@interface ZPDFPageModel(){
    
        NSUInteger _chapter;    //当前显示的章节
        NSUInteger _page;       //当前显示的页数
        NSUInteger _chapterChange;  //将要变化的章节
        NSUInteger _pageChange;     //将要变化的页数
        BOOL _isTransition;     //是否开始翻页
    

}
@end

@implementation ZPDFPageModel

-(id) initWithPDFDocument:(CGPDFDocumentRef) pdfDoc {
        if (self) {
        pdfDocument = pdfDoc;
              
    }
    return self;
}


- (ZPDFPageController *)viewControllerAtIndex:(NSUInteger)pageNO withChapterNO:(NSUInteger)chapterNO {
    // Return the data view controller for the given index.
    long pageSum = CGPDFDocumentGetNumberOfPages(pdfDocument);
    if (pageSum== 0 || pageNO >= pageSum+1) {
        return nil;
    }
    if(chapterNO >= self.model.chapters.count){
        return nil;
    }
    // Create a new view controller and pass suitable data.
    ZPDFPageController *pageController = [[ZPDFPageController alloc] init];
    pageController.pdfDocument = pdfDocument;
    pageController.pageNO  = pageNO;
    pageController.chapterNO = chapterNO;
    _chapter = chapterNO;
    //[self pageChanged:pageNO withChapter: chapterNO];
    [self updateReadModelWithChapter:_chapter page:pageNO];
    return pageController;
}

- (NSUInteger)indexOfViewController:(ZPDFPageController *)viewController {
    return viewController.pageNO;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController: (ZPDFPageController *)viewController];
    if ((index == 1) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    
    if(_chapter>=1){
         LSYChapterModel* itemTemp = self.model.chapters[_chapter-1];//本章的第一页的页码
        if((index == itemTemp.pageCount-1)){
            _chapter--;
        }
    }
    //存储变化的页码//存储变化的章节
   // [self pageChanged:index withChapter:_chapter];

  [self updateReadModelWithChapter:_chapter page:index];

    if(_delegate && [_delegate respondsToSelector:@selector(pageChanged:)])
    {
        [_delegate pageChanged:index];
    }
    return [self viewControllerAtIndex:index withChapterNO:_chapter];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController: (ZPDFPageController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    long pageSum = CGPDFDocumentGetNumberOfPages(pdfDocument);
    if (index >= pageSum+1) {
        return nil;
    }
    
    
    if(_chapter< self.model.chapters.count-1){
      LSYChapterModel* itemTemp = self.model.chapters[_chapter+1];//下一章的第一页
      if((index == itemTemp.pageCount)){
         _chapter++;
      }
    }
    //存储变化的页码//存储变化的章节
    //[self pageChanged:index withChapter:_chapter];
    [self updateReadModelWithChapter:_chapter page:index];

    if(_delegate && [_delegate respondsToSelector:@selector(pageChanged:)])
    {
        [_delegate pageChanged:index];
    }
    return [self viewControllerAtIndex:index withChapterNO:_chapter];
}

//-(void)pageChanged:(NSInteger)page withChapter:(NSInteger)chapter
//{
//    [[NSUserDefaults standardUserDefaults] setInteger:page forKey:[_fileName stringByAppendingString:@"page"]];
//    [[NSUserDefaults standardUserDefaults] setInteger:chapter forKey:[_fileName stringByAppendingString:@"chapter"]];
//    
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    NSLog(@"PageChanged @%ld",(long)page);
//}

-(void)updateReadModelWithChapter:(NSUInteger)chapter page:(NSUInteger)page
{

    self.model.record.chapterModel = self.model.chapters[chapter];
    self.model.record.chapter = chapter;
    self.model.record.page = page;
    [LSYReadModel updateLocalModel:self.model url:_resourceURL];
}


@end
