//
//  LSYReadPageViewController.m
//  LSYReader
//
//  Created by Labanotation on 16/5/30.
//  Copyright © 2016年 okwei. All rights reserved.
//
#import "PDFDocumentOutlineItem.h"
#import "LSYReadPageViewController.h"
#import "LSYReadViewController.h"
#import "LSYChapterModel.h"
#import "LSYMenuView.h"
#import "LSYCatalogViewController.h"
#import "UIImage+ImageEffects.h"
#import "LSYNoteModel.h"
#import "LSYMarkModel.h"
#import "ZPDFReaderController.h"
#import "ZPDFPageController.h"
#import "ZPDFPageModel.h"
#import"LSYReadUtilites.h"
#define AnimationDelay 0.3

@interface LSYReadPageViewController ()<ZPDFPageModelDelegate,UIPageViewControllerDelegate,UIPageViewControllerDataSource,LSYMenuViewDelegate,UIGestureRecognizerDelegate,LSYCatalogViewControllerDelegate,LSYReadViewControllerDelegate>
{
    NSUInteger _chapter;    //当前显示的章节
    NSUInteger _page;       //当前显示的页数
    NSUInteger _chapterChange;  //将要变化的章节
    NSUInteger _pageChange;     //将要变化的页数
    BOOL _isTransition;     //是否开始翻页
    ZPDFPageModel *pdfPageModel;;
    CGPDFDocumentRef pdfDocument;
}

@property (nonatomic,strong) UIPageViewController *pageViewController;
@property (nonatomic,getter=isShowBar) BOOL showBar; //是否显示状态栏
@property (nonatomic,strong) LSYMenuView *menuView; //菜单栏
@property (nonatomic,strong) LSYCatalogViewController *catalogVC;   //侧边栏
@property (nonatomic,strong) UIView * catalogView;  //侧边栏背景
@property (nonatomic,strong) LSYReadViewController *readView;   //当前阅读视图
@end

@implementation LSYReadPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   

    if(self.isPDF==YES){
        //initial UIPageViewController
        NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
        self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                       navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                     options:options];
        
        

    //setting DataSource
//    CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), (__bridge CFStringRef)self.fileName, NULL, (__bridge CFStringRef)self.subDirName);
    pdfDocument =  [LSYReadUtilites pdfRefByFilePath:[self.resourceURL absoluteString]];;
   // CFRelease();
    pdfPageModel = [[ZPDFPageModel alloc] initWithPDFDocument:pdfDocument];
    pdfPageModel.delegate=self;
    pdfPageModel.model = self.model;
    pdfPageModel.fileName = self.fileName;
    pdfPageModel.resourceURL = self.resourceURL;
    [self.pageViewController setDataSource:pdfPageModel];
    
    //NSInteger pageFromLocal = [[NSUserDefaults standardUserDefaults] integerForKey:[_fileName stringByAppendingString:@"page"]];
    //NSInteger chapterFromLocal = [[NSUserDefaults standardUserDefaults] integerForKey:[_fileName stringByAppendingString:@"chapter"]];
        
    //setting initial VCs
    //int pageFromModel= _model.record.page;
        ZPDFPageController *initialViewController = [pdfPageModel viewControllerAtIndex:MAX(_model.record.page, 1) withChapterNO:_model.record.chapter];
    NSArray *viewControllers = @[initialViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    [self.view addSubview:self.pageViewController.view];
    [self addChildViewController:self.pageViewController];
    //_page = pageFromLocal;
        _page = _model.record.page;

   }else{
       
       [self addChildViewController:self.pageViewController];
       [_pageViewController setViewControllers:@[[self readViewWithChapter:_model.record.chapter page:_model.record.page]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
       _page = _model.record.page;

    }
    
        _chapter = _model.record.chapter;
    
    
    [self.view addGestureRecognizer:({
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showToolMenu)];
        tap.delegate = self;
        tap;
    })];
    [self.view addSubview:self.menuView];
    
    [self addChildViewController:self.catalogVC];
    [self.view addSubview:self.catalogView];
    [self.catalogView addSubview:self.catalogVC.view];
    //添加笔记
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNotes:) name:LSYNoteNotification object:nil];

}

-(void)addNotes:(NSNotification *)no
{
    LSYNoteModel *model = no.object;
    model.recordModel = [_model.record copy];
    [[_model mutableArrayValueForKey:@"notes"] addObject:model];    //这样写才能KVO数组变化
    [LSYReadUtilites showAlertTitle:nil content:@"保存笔记成功"];
}

-(BOOL)prefersStatusBarHidden
{
    return !_showBar;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)showToolMenu
{
    [_readView.readView cancelSelected];
    [self.menuView showAnimation:YES];
    
}

#pragma mark - init
-(LSYMenuView *)menuView
{
    if (!_menuView) {
        _menuView = [[LSYMenuView alloc] init];
        _menuView.hidden = YES;
        _menuView.delegate = self;
        _menuView.recordModel = _model.record;
    }
    return _menuView;
}
-(UIPageViewController *)pageViewController
{
    if (!_pageViewController&&!self.isPDF) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        [self.view addSubview:_pageViewController.view];
    }
    return _pageViewController;
}
-(LSYCatalogViewController *)catalogVC
{
    if (!_catalogVC) {
        _catalogVC = [[LSYCatalogViewController alloc] init];
        _catalogVC.readModel = _model;
        _catalogVC.catalogDelegate = self;
    }
    return _catalogVC;
}
-(UIView *)catalogView
{
    if (!_catalogView) {
        _catalogView = [[UIView alloc] init];
        _catalogView.backgroundColor = [UIColor clearColor];
        _catalogView.hidden = YES;
        [_catalogView addGestureRecognizer:({
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenCatalog)];
            tap.delegate = self;
            tap;
        })];
    }
    return _catalogView;
}
#pragma mark - CatalogViewController Delegate
-(void)catalog:(LSYCatalogViewController *)catalog didSelectChapter:(NSUInteger)chapter page:(NSUInteger)page
{  if(!self.isPDF){
    [_pageViewController setViewControllers:@[[self readViewWithChapter:chapter page:page]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self updateReadModelWithChapter:chapter page:page];
}else{
    // Return the data view controller for the given index.
    long pageSum = CGPDFDocumentGetNumberOfPages(pdfDocument);
    if (pageSum== 0 || page >= pageSum+1) {//错误处理
        //return nil;
    }
    // Create a new view controller and pass suitable data.
    //ZPDFPageController *pageController = [[ZPDFPageController alloc] init];
    LSYChapterModel* item = [_model.chapters objectAtIndex:chapter];
    ZPDFPageController *pageController = [pdfPageModel viewControllerAtIndex:item.pageCount withChapterNO:chapter];
    //pageController.pdfDocument = pdfDocument;
        //pageController.pageNO  = item.pageCount;
    //pageController.chapterNO = chapter;
    [_pageViewController setViewControllers: @[pageController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self updateReadModelWithChapter:chapter page:item.pageCount];//更新选择目录时的页码
    //[[NSUserDefaults standardUserDefaults] setInteger:pageController.pageNO forKey:[_fileName stringByAppendingString:@"page"]];
    //[[NSUserDefaults standardUserDefaults] setInteger:pageController.chapterNO forKey:[_fileName stringByAppendingString:@"chapter"]];
    //[[NSUserDefaults standardUserDefaults] synchronize];


}
       [self hiddenCatalog];
    
}

//-(void)pageChanged:(NSInteger)page
//{
//    [[NSUserDefaults standardUserDefaults] setInteger:page forKey:_fileName];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}


#pragma mark -  UIGestureRecognizer Delegate
//解决TabView与Tap手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
#pragma mark - Privite Method
-(void)catalogShowState:(BOOL)show
{
    show?({
        _catalogView.hidden = !show;
        [UIView animateWithDuration:AnimationDelay animations:^{
            _catalogView.frame = CGRectMake(0, 0,2*ViewSize(self.view).width, ViewSize(self.view).height);
            
        } completion:^(BOOL finished) {
            [_catalogView insertSubview:[[UIImageView alloc] initWithImage:[self blurredSnapshot]] atIndex:0];
        }];
    }):({
        if ([_catalogView.subviews.firstObject isKindOfClass:[UIImageView class]]) {
            [_catalogView.subviews.firstObject removeFromSuperview];
        }
        [UIView animateWithDuration:AnimationDelay animations:^{
             _catalogView.frame = CGRectMake(-ViewSize(self.view).width, 0, 2*ViewSize(self.view).width, ViewSize(self.view).height);
        } completion:^(BOOL finished) {
            _catalogView.hidden = !show;
            
        }];
    });
}
-(void)hiddenCatalog
{
    [self catalogShowState:NO];
}
- (UIImage *)blurredSnapshot {
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)), NO, 1.0f);
    [self.view drawViewHierarchyInRect:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) afterScreenUpdates:NO];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImage *blurredSnapshotImage = [snapshotImage applyLightEffect];
    UIGraphicsEndImageContext();
    return blurredSnapshotImage;
}
#pragma mark - Menu View Delegate
-(void)menuViewDidHidden:(LSYMenuView *)menu
{
     _showBar = NO;
    [self setNeedsStatusBarAppearanceUpdate];
}
-(void)menuViewDidAppear:(LSYMenuView *)menu
{
    _showBar = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    
}
-(void)menuViewInvokeCatalog:(LSYBottomMenuView *)bottomMenu
{
    [_menuView hiddenAnimation:NO];
    [self catalogShowState:YES];
    
}
#pragma mark- 底部菜单栏跳往下一章 上一章
-(void)menuViewJumpChapter:(NSUInteger)chapter page:(NSUInteger)page
{
    if(!self.isPDF){
        [_pageViewController setViewControllers:@[[self readViewWithChapter:chapter page:page]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        [self updateReadModelWithChapter:chapter page:page];
    }else{
        long pageSum = CGPDFDocumentGetNumberOfPages(pdfDocument);
        if (pageSum== 0 || page >= pageSum+1) {//错误处理
            //return nil;
        }
        LSYChapterModel* item = [_model.chapters objectAtIndex:chapter];
        ZPDFPageController *pageController = [pdfPageModel viewControllerAtIndex:item.pageCount withChapterNO:chapter];
        [_pageViewController setViewControllers: @[pageController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        [self updateReadModelWithChapter:chapter page:item.pageCount];
    }
    
    
}

#pragma mark-底部菜单栏 改变字体大小
-(void)menuViewFontSize:(LSYBottomMenuView *)bottomMenu
{
    if([_model.content isEqualToString:@""]){
        //ZPDFPageController *pageController =  _pageViewController.presentedViewController;
        //UIScrollView *scrollView = pageController.view;
    }else{
        [_model.record.chapterModel updateFont];
        [_pageViewController setViewControllers:@[[self readViewWithChapter:_model.record.chapter page:(_model.record.page>_model.record.chapterModel.pageCount-1)?_model.record.chapterModel.pageCount-1:_model.record.page]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        [self updateReadModelWithChapter:_model.record.chapter page:(_model.record.page>_model.record.chapterModel.pageCount-1)?_model.record.chapterModel.pageCount-1:_model.record.page];
    }
    
}
-(void)menuViewMark:(LSYTopMenuView *)topMenu
{

    LSYMarkModel *model = [[LSYMarkModel alloc] init];
    model.date = [NSDate date];
    model.recordModel = [_model.record copy];
    NSMutableSet* markSet;
    if(markSet==nil){
         markSet = [[NSMutableSet alloc]init];
       for(LSYMarkModel* element in _model.marks){//书签去重
        [markSet addObject:element.recordModel.chapterModel.title];
       }
    }
    if(![markSet containsObject:model.recordModel.chapterModel.title]){
        [[_model mutableArrayValueForKey:@"marks"] addObject:model];
    }else{
        
    }

}
#pragma mark - Create Read View Controller

-(LSYReadViewController *)readViewWithChapter:(NSUInteger)chapter page:(NSUInteger)page{

    
    if (_model.record.chapter != chapter) {
        [_model.record.chapterModel updateFont];
    }
    _readView = [[LSYReadViewController alloc] init];
    _readView.recordModel = _model.record;
    _readView.isPDF = self.isPDF;
    _readView.fileName = self.fileName;
    _readView.subDirName = self.subDirName;
    if(_isPDF==NO){
        _readView.content = [_model.chapters[chapter] stringOfPage:page];
    }else{
        _readView.content = @"";
//        //setting DataSource
//        CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), (__bridge CFStringRef)self.fileName, NULL, (__bridge CFStringRef)self.subDirName);
//        CGPDFDocumentRef pdfDocument = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
//        CFRelease(pdfURL);
//        pdfPageModel = [[ZPDFPageModel alloc] initWithPDFDocument:pdfDocument];
//        pdfPageModel.delegate=self;
//        [_readView setDataSource:pdfPageModel];
//        
//        NSInteger page = [[NSUserDefaults standardUserDefaults] integerForKey:_fileName];
//        
//        //setting initial VCs
//        ZPDFPageController *initialViewController = [pdfPageModel viewControllerAtIndex:MAX(page, 1)];
//        NSArray *viewControllers = @[initialViewController];
//        [pageViewCtrl setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];

    }
    _readView.delegate = self;
    NSLog(@"_readGreate");
    
    return _readView;
}
-(void)updateReadModelWithChapter:(NSUInteger)chapter page:(NSUInteger)page
{
    _chapter = chapter;
    _page = page;
    _model.record.chapterModel = _model.chapters[chapter];
    _model.record.chapter = chapter;
    _model.record.page = page;
    [LSYReadModel updateLocalModel:_model url:_resourceURL];
}
#pragma mark - Read View Controller Delegate
-(void)readViewEndEdit:(LSYReadViewController *)readView
{
    for (UIGestureRecognizer *ges in self.pageViewController.view.gestureRecognizers) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled = YES;
            break;
        }
    }
}
-(void)readViewEditeding:(LSYReadViewController *)readView
{
    for (UIGestureRecognizer *ges in self.pageViewController.view.gestureRecognizers) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled = NO;
            break;
        }
    }
}
#pragma mark -PageViewController DataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{

    _pageChange = _page;
    _chapterChange = _chapter;

    if (_chapterChange==0 &&_pageChange == 0) {
        return nil;
    }
    if (_pageChange==0) {
        _chapterChange--;
        _pageChange = _model.chapters[_chapterChange].pageCount-1;
    }
    else{
        _pageChange--;
    }
    
    return [self readViewWithChapter:_chapterChange page:_pageChange];
    
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{

    _pageChange = _page;
    _chapterChange = _chapter;
    if (_pageChange == _model.chapters.lastObject.pageCount-1 && _chapterChange == _model.chapters.count-1) {
        return nil;
    }
    if (_pageChange == _model.chapters[_chapterChange].pageCount-1) {
        _chapterChange++;
        _pageChange = 0;
    }
    else{
        _pageChange++;
    }
    return [self readViewWithChapter:_chapterChange page:_pageChange];
}
#pragma mark -PageViewController Delegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed) {
        LSYReadViewController *readView = previousViewControllers.firstObject;
        _readView = readView;
        _page = readView.recordModel.page;
        _chapter = readView.recordModel.chapter;
    }
    else{
        [self updateReadModelWithChapter:_chapter page:_page];
    }
}
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    _chapter = _chapterChange;
    _page = _pageChange;
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    _pageViewController.view.frame = self.view.frame;
    _menuView.frame = self.view.frame;
    _catalogView.frame = CGRectMake(-ViewSize(self.view).width, 0, 2*ViewSize(self.view).width, ViewSize(self.view).height);
    _catalogVC.view.frame = CGRectMake(0, 0, ViewSize(self.view).width-100, ViewSize(self.view).height);
    [_catalogVC reload];
}

- (ZPDFPageController *)viewControllerAtIndex:(NSUInteger)pageNO {
    // Return the data view controller for the given index.
    long pageSum = CGPDFDocumentGetNumberOfPages(pdfDocument);
    if (pageSum== 0 || pageNO >= pageSum+1) {
        return nil;
    }
    // Create a new view controller and pass suitable data.
    ZPDFPageController *pageController = [[ZPDFPageController alloc] init];
    pageController.pdfDocument = pdfDocument;
    pageController.pageNO  = pageNO;
    return pageController;
}
//-(void)dealloc{
// [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

@end
