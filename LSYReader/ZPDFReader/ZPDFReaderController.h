//
//  ZPDFReaderController.h
//  pdfReader
//
//  Created by XuJackie on 15/6/6.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPDFPageModel.h"
#import "LSYMenuView.h"
@interface ZPDFReaderController : UIViewController<ZPDFPageModelDelegate>

@property(nonatomic,copy)NSString *fileName, *subDirName;
@property (nonatomic,strong) LSYMenuView *menuView; //上下菜单栏

@end
