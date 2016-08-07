//
//  BookStoreTableViewCell.h
//  LSYReader
//
//  Created by hongli on 16/7/29.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import"BookModel.h"

@protocol StartReadAfterDownloadDelegate<NSObject>

-(void)StartReadingWithBookModel:(BookModel*)model;

@end

@interface BookStoreTableViewCell : UITableViewCell<NSURLSessionDownloadDelegate>
@property(nonatomic,copy)UILabel* bookTitle;
@property(nonatomic,copy)UILabel* authorName ;
@property(nonatomic,copy)UIButton* downloadBtn;
@property(nonatomic,copy)UIProgressView* progressBar;
@property (strong, nonatomic)NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDownloadTask *task;
@property (nonatomic, strong) NSData *resumeData;//保留下载进度
@property(nonatomic,strong)BookModel* model;
@property (nonatomic,weak)id<StartReadAfterDownloadDelegate> delegate;
-(void) cellBindingwithBookModel:(BookModel*) model;
@end
