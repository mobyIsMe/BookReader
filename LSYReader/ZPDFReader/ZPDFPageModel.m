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
    self = [super init];
    if (self) {
        pdfDocument = pdfDoc;
        //获取目录字典
        _items = [[PDFDocumentOutline alloc]outlineItemsForDocument:pdfDocument];
        super.chapters = [self getChapters:_items];
       super.notes = [NSMutableArray array];
       super.marks = [NSMutableArray array];
        super.record = [[LSYRecordModel alloc] init];
        super.record.chapterModel = super.chapters.firstObject;
        super.record.chapterCount = super.chapters.count;

    }
    return self;
}

-(NSMutableArray*)getChapters:(NSArray*)chapterArray{
    NSMutableArray* chapters = [[NSMutableArray alloc]init];
    for (PDFDocumentOutlineItem* element in chapterArray){
        LSYChapterModel *model = [LSYChapterModel chapterWithPdf:element.title WithPageCount:element.pageNumber];
        [chapters addObject:model];
        
    }
    
    return chapters;
}


- (ZPDFPageController *)viewControllerAtIndex:(NSUInteger)pageNO withChapterNO:(NSUInteger)chapterNO {
    // Return the data view controller for the given index.
    long pageSum = CGPDFDocumentGetNumberOfPages(pdfDocument);
    if (pageSum== 0 || pageNO >= pageSum+1) {
        return nil;
    }
    if(chapterNO==0||chapterNO>=super.chapters.count+1){
        return nil;
    }
    // Create a new view controller and pass suitable data.
    ZPDFPageController *pageController = [[ZPDFPageController alloc] init];
    pageController.pdfDocument = pdfDocument;
    pageController.pageNO  = pageNO;
    pageController.chapterNO = chapterNO;
    _chapter = chapterNO;
    [self pageChanged:pageNO withChapter: chapterNO];
    //updateReadModelWithpage:pageNO;
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
    
    if(_chapter>0){
        PDFDocumentOutlineItem* itemTemp = _items[_chapter-1];//本章的第一页的页码
        if((index == itemTemp.pageNumber-1)){
            _chapter--;
        }
    }
    //存储变化的页码//存储变化的章节
    [self pageChanged:index withChapter:_chapter];
    
    //return [self readViewWithChapter:_chapterChange page:_pageChange];

    //[self updateReadModelWithChapter:_chapter page:_page];
    

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
    
    
    if(_chapter<= _items.count){
      PDFDocumentOutlineItem* itemTemp = _items[_chapter];//下一章的第一页
      if((index == itemTemp.pageNumber)){
         _chapter++;
      }
    }
    //存储变化的页码//存储变化的章节
    [self pageChanged:index withChapter:_chapter];
    //[self updateReadModelWithChapter:_chapter page:_page];

    if(_delegate && [_delegate respondsToSelector:@selector(pageChanged:)])
    {
        [_delegate pageChanged:index];
    }
    return [self viewControllerAtIndex:index withChapterNO:_chapter];
}

-(void)pageChanged:(NSInteger)page withChapter:(NSInteger)chapter
{
    [[NSUserDefaults standardUserDefaults] setInteger:page forKey:[_fileName stringByAppendingString:@"page"]];
    [[NSUserDefaults standardUserDefaults] setInteger:chapter forKey:[_fileName stringByAppendingString:@"chapter"]];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"PageChanged @%ld",(long)page);
}

-(void)updateReadModelWithChapter:(NSUInteger)chapter page:(NSUInteger)page
{

    super.record.chapterModel = super.chapters[chapter];
    super.record.chapter = chapter;
    super.record.page = page;
    [LSYReadModel updateLocalModel:self url:_resourceURL];
}


@end
