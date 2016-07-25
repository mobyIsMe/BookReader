//
//  ZPDFPageController.m
//  pdfReader
//
//  Created by XuJackie on 15/6/6.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import "ZPDFPageController.h"
#import "ZPDFView.h"


@interface ZPDFPageController()
{
    ZPDFView *pdfView;
}

@end

@implementation ZPDFPageController//这里控制每个页面的view的显示

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prefersStatusBarHidden];
    //[self.view setBackgroundColor:[LSYReadConfig shareInstance].theme];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
   scrollView.showsVerticalScrollIndicator=NO;
   scrollView.showsHorizontalScrollIndicator=NO;
   scrollView.minimumZoomScale=1.0f;
   scrollView.maximumZoomScale=3.0f;
   scrollView.delegate=self;
   [self.view addSubview:scrollView];
    //[self.view addSubview:self.readView];
    pdfView = [[ZPDFView alloc] initWithFrame:scrollView.bounds atPage:(int)self.pageNO withPDFDoc:self.pdfDocument];
    pdfView.backgroundColor=[UIColor whiteColor];
    [scrollView addSubview:pdfView];
    
    scrollView.contentSize=pdfView.bounds.size;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheme:) name:LSYThemeNotification object:nil];

}


//-(void)changeTheme:(NSNotification *)no
//{
//    [LSYReadConfig shareInstance].theme = no.object;
//    [self.view setBackgroundColor:[LSYReadConfig shareInstance].theme];
//}
//-(LSYReadView *)readView
//{
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//    scrollView.showsVerticalScrollIndicator=NO;
//    scrollView.showsHorizontalScrollIndicator=NO;
//    scrollView.minimumZoomScale=1.0f;
//    scrollView.maximumZoomScale=3.0f;
//    scrollView.delegate=self;
//    [self.view addSubview:scrollView];
//    
//    super.readView = [[ZPDFView alloc] initWithFrame:scrollView.bounds atPage:(int)self.pageNO withPDFDoc:self.pdfDocument];
//    super.readView.backgroundColor=[UIColor whiteColor];
//    
//    scrollView.contentSize=super.readView .bounds.size;
//    LSYReadConfig *config = [LSYReadConfig shareInstance];
//    super.readView.frameRef = [LSYReadParser parserContent:super.content config:config bouds:CGRectMake(0,0, super.readView.frame.size.width, super.readView.frame.size.height)];
//    super.readView.content = super.content;
//    super.readView.delegate = self;
//    
//    
//    //    if (!_readView) {
//    //        pdfView = [[ZPDFView alloc] initWithFrame:scrollView.bounds atPage:(int)self.pageNO withPDFDoc:self.pdfDocument];
//    //        pdfView.backgroundColor=[UIColor whiteColor];
//    //        [scrollView addSubview:pdfView];
//    //
//    //        _readView = [[LSYReadView alloc] initWithFrame:CGRectMake(LeftSpacing,TopSpacing, self.view.frame.size.width-LeftSpacing-RightSpacing, self.view.frame.size.height-TopSpacing-BottomSpacing)];
//    //        LSYReadConfig *config = [LSYReadConfig shareInstance];
//    //        _readView.frameRef = [LSYReadParser parserContent:_content config:config bouds:CGRectMake(0,0, _readView.frame.size.width, _readView.frame.size.height)];
//    //        _readView.content = _content;
//    //        _readView.delegate = self;
//    //    }
//    return super.readView;
//}
//-(void)readViewEditeding:(LSYReadViewController *)readView
//{
//    if ([self.delegate respondsToSelector:@selector(readViewEditeding:)]) {
//        [self.delegate readViewEditeding:self];
//    }
//}
//-(void)readViewEndEdit:(LSYReadViewController *)readView
//{
//    if ([self.delegate respondsToSelector:@selector(readViewEndEdit:)]) {
//        [self.delegate readViewEndEdit:self];
//    }
//}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}


//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
//{
//    return super.readView;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end




