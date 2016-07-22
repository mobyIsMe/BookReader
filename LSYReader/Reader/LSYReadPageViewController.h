//
//  LSYReadPageViewController.h
//  LSYReader
//
//  Created by Labanotation on 16/5/30.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSYReadModel.h"
#import "ZPDFPageModel.h"
@interface LSYReadPageViewController : UIViewController
@property (nonatomic,strong) NSURL *resourceURL;
@property (nonatomic,strong) LSYReadModel *model;
@property(nonatomic,copy)NSString *fileName, *subDirName;
@property Boolean isPDF;
//+(void)loadURL:(NSURL *)url;
@end
