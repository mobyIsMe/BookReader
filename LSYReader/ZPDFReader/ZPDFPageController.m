//
//  ZPDFPageController.m
//  pdfReader
//
//  Created by XuJackie on 15/6/6.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import "ZPDFPageController.h"


static Boolean isThemeChanged;
static UIColor* themeChangeColor;

@interface ZPDFPageController()
{
    
}

@end

@implementation ZPDFPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prefersStatusBarHidden];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheme:) name:LSYThemeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFont:) name:@"LSYFontNotification" object:nil];
    //[self.view setBackgroundColor:[LSYReadConfig shareInstance].theme];
   _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
   _scrollView.showsVerticalScrollIndicator=NO;
   _scrollView.showsHorizontalScrollIndicator=NO;
   _scrollView.minimumZoomScale=1.0f;
   _scrollView.maximumZoomScale=3.0f;
   _scrollView.delegate=self;
   [self.view addSubview:_scrollView];
    //[self.view addSubview:self.readView];
    _pdfView = [[ZPDFView alloc] initWithFrame:_scrollView.bounds atPage:(int)self.pageNO withPDFDoc:self.pdfDocument];
    _pdfView.backgroundColor=[UIColor clearColor];
    if(isThemeChanged){
         _scrollView.backgroundColor = themeChangeColor;
    }else{
         _scrollView.backgroundColor = [UIColor whiteColor];
    }
   
    [_scrollView addSubview:_pdfView];
    
    _scrollView.contentSize=_pdfView.bounds.size;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheme:) name:LSYThemeNotification object:nil];

}

#pragma mark- 改变PDF的背景色的通知
-(void)changeTheme:(NSNotification *)no{
    [LSYReadConfig shareInstance].theme = no.object;
    _scrollView.backgroundColor=[LSYReadConfig shareInstance].theme;
    themeChangeColor = _scrollView.backgroundColor;
    isThemeChanged = YES;
}
-(void)changeFont:(NSNotification *)no{///放大或减小视图
    NSString* fontStr = no.object;
    CGFloat scale;
    if([fontStr isEqualToString:@"increaseFont"]){
        scale = _scrollView.zoomScale+0.2;
    }else{
        scale = _scrollView.zoomScale-0.2;
    }
    
    CGFloat w= _pdfView.frame.size.width*scale;
    CGFloat h= _pdfView.frame.size.height*scale;
    
    [_scrollView zoomToRect:CGRectMake(0, 0, w, h) animated:YES];
    _pdfView.contentSize = CGSizeMake(_scrollView.bounds.size.width, _scrollView.bounds.size.height );
    _pdfView.frame = CGRectMake(0, 0, w, h);
}

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




