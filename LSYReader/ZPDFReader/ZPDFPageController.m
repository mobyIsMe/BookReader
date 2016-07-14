//
//  ZPDFPageController.m
//  pdfReader
//
//  Created by XuJackie on 15/6/6.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import "ZPDFPageController.h"
#import "ZPDFView.h"

@interface ZPDFPageController()<UIScrollViewDelegate>
{
    ZPDFView *pdfView;
}

@end

@implementation ZPDFPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.minimumZoomScale=1.0f;
    scrollView.maximumZoomScale=3.0f;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    pdfView = [[ZPDFView alloc] initWithFrame:scrollView.bounds atPage:(int)self.pageNO withPDFDoc:self.pdfDocument];
    pdfView.backgroundColor=[UIColor whiteColor];
    [scrollView addSubview:pdfView];
    
    scrollView.contentSize=pdfView.bounds.size;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return pdfView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
