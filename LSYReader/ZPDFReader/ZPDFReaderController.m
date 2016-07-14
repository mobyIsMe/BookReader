//
//  ZPDFReaderController.m
//  pdfReader
//
//  Created by XuJackie on 15/6/6.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import "ZPDFReaderController.h"
#import "ZPDFPageController.h"
#import "LSYMenuView.h"
#define IOS7 ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0)

@interface ZPDFReaderController()<LSYMenuViewDelegate>{
    //这里添加上章节、页数等
   /* NSUInteger _chapter;    //当前显示的章节
    NSUInteger _page;       //当前显示的页数
    NSUInteger _chapterChange;  //将要变化的章节
    NSUInteger _pageChange;     //将要变化的页数
    BOOL _isTransition;     //是否开始翻页
    */
}
@property (nonatomic,getter=isShowBar) BOOL showBar; //是否显示状态栏

@end
@implementation ZPDFReaderController
{
    UIPageViewController *pageViewCtrl;
    ZPDFPageModel *pdfPageModel;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏
    self.navigationItem.title = [self.fileName substringToIndex:self.fileName.length-4];
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftBtn.frame = CGRectMake(0, 7, 25, 25);
    UIImage *btnImage = [UIImage imageNamed:@"back_nav@2x.png"];
    [leftBtn setImage:btnImage forState:UIControlStateNormal];
    //leftBtn.backgroundColor = [UIColor orangeColor];
    [leftBtn addTarget:self action:@selector(navigationBackButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
        
    if(IOS7)
    {
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    
    //[self.view addSubview:self.menuView];//添加上下菜单栏
   
    
    //initial UIPageViewController
    NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
    pageViewCtrl = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                   navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                 options:options];
    
    //setting DataSource
    CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), (__bridge CFStringRef)self.fileName, NULL, (__bridge CFStringRef)self.subDirName);
    CGPDFDocumentRef pdfDocument = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
    CFRelease(pdfURL);
    pdfPageModel = [[ZPDFPageModel alloc] initWithPDFDocument:pdfDocument];
    pdfPageModel.delegate=self;
    [pageViewCtrl setDataSource:pdfPageModel];
    
    NSInteger page = [[NSUserDefaults standardUserDefaults] integerForKey:_fileName];
    
    //setting initial VCs
    ZPDFPageController *initialViewController = [pdfPageModel viewControllerAtIndex:MAX(page, 1)];
    NSArray *viewControllers = @[initialViewController];
    [pageViewCtrl setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    
    //show UIPageViewController
    [self addChildViewController:pageViewCtrl];
    [self.view addSubview:pageViewCtrl.view];
    [pageViewCtrl didMoveToParentViewController:self];
}


#pragma mark- 设置导航栏
- (void)setNavigationbar
{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 44)];
    navigationBar.tintColor = [UIColor redColor];
    
    //创建UINavigationItem
    UINavigationItem * navigationBarTitle = [[UINavigationItem alloc] initWithTitle:@"创建UINavigationBar"];
    [navigationBar pushNavigationItem: navigationBarTitle animated:YES];
    [self.view addSubview: navigationBar];
    //创建UIBarButton 可根据需要选择适合自己的样式
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(navigationBackButton)];
    //设置barbutton
    navigationBarTitle.leftBarButtonItem = item;
    [navigationBar setItems:[NSArray arrayWithObject: navigationBarTitle]];

    
}

#pragma mark- 导航栏返回
- (void) navigationBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- Menu View
-(LSYMenuView *)menuView
{
    if (!_menuView) {
        _menuView = [[LSYMenuView alloc] init];
        _menuView.hidden = YES;
        _menuView.delegate = self;
        //_menuView.recordModel = _model.record;//这个跟添加笔记有关
    }
    return _menuView;
}

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
//-(void)menuViewInvokeCatalog:(LSYBottomMenuView *)bottomMenu
//{
//    [_menuView hiddenAnimation:NO];
//    [self catalogShowState:YES];
//    
//}

//-(void)menuViewJumpChapter:(NSUInteger)chapter page:(NSUInteger)page
//{
//    [_pageViewController setViewControllers:@[[self readViewWithChapter:chapter page:page]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
//    [self updateReadModelWithChapter:chapter page:page];
//}
//-(void)menuViewFontSize:(LSYBottomMenuView *)bottomMenu
//{
//    
//    [_model.record.chapterModel updateFont];
//    [_pageViewController setViewControllers:@[[self readViewWithChapter:_model.record.chapter page:(_model.record.page>_model.record.chapterModel.pageCount-1)?_model.record.chapterModel.pageCount-1:_model.record.page]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
//    [self updateReadModelWithChapter:_model.record.chapter page:(_model.record.page>_model.record.chapterModel.pageCount-1)?_model.record.chapterModel.pageCount-1:_model.record.page];
//}




-(void)menuViewMark:(LSYTopMenuView *)topMenu
{
    
    LSYMarkModel *model = [[LSYMarkModel alloc] init];
    model.date = [NSDate date];
    //model.recordModel = [_model.record copy];
    //[[_model mutableArrayValueForKey:@"marks"] addObject:model];
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

-(void)pageChanged:(NSInteger)page
{
    [[NSUserDefaults standardUserDefaults] setInteger:page forKey:_fileName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
