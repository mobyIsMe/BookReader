//
//  BookStoreTableViewCell.m
//  LSYReader
//
//  Created by hongli on 16/7/29.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "BookStoreTableViewCell.h"

@implementation BookStoreTableViewCell
/**
 *  session的懒加载
 */
- (NSURLSession *)session
{
    if (nil == _session) {
        
        NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:cfg delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

-(void) cellBindingwithBookModel:(BookModel*) model{
    self.model = model;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        int frameWidth = CGRectGetWidth(self.frame);
        int frameHeight = CGRectGetHeight(self.frame);
        _bookTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, frameWidth/3, 20)];
        _authorName = [[UILabel alloc]initWithFrame:CGRectMake(_bookTitle.frame.size.width+20, 20, frameWidth/3, 20)];
       _downloadBtn = [[UIButton alloc]initWithFrame:CGRectMake(_bookTitle.frame.size.width+_authorName.frame.size.width+30, 20, frameWidth/3-10, 20)];
        _progressBar = [[UIProgressView alloc]initWithFrame:CGRectMake(20, frameHeight, frameWidth, 10)];
        _progressBar.progress = 0;
        
        [_bookTitle setText:@"书名"];
        [_authorName setText:@"作者名"];
        [_downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
        [_downloadBtn setBackgroundColor:[UIColor grayColor]];
        [_downloadBtn addTarget:self action:@selector(downloadBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bookTitle];
        [self addSubview:_authorName];
        [self addSubview:_downloadBtn];
        [self addSubview:_progressBar];
    }
    return self;
}

-(void)downloadBtnPressed:(UIButton*)btn{
    //实现按钮不同状态的切换
    
    btn.selected=!btn.selected;
    if(![[btn currentTitle]isEqualToString:@"开始阅读"]){
        [self.progressBar setHidden:NO];
        if(self.task==nil){
            if (self.resumeData) { // 继续下载
                [self resume];
            }else{ // 从0开始下载
                [self startDownload];
            }
        }else{ // 暂停
            [self pause];
        }

    }else{//开始阅读
        NSString *resourcePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"/files"];
        _model.filePath = [resourcePath stringByAppendingString:[@"/" stringByAppendingString:[_model.downloadURL lastPathComponent]]];
        [_delegate StartReadingWithBookModel:_model];
    }
    
}



#pragma mark 点击开始下载
-(void)startDownload{
    [_downloadBtn setTitle:@"下载中..." forState:UIControlStateNormal];
    //如果不调用session的点语法，就不会执行懒加载的实例化那一步！
//    self.task = [self.session downloadTaskWithURL:[NSURL URLWithString:@"https://manuals.info.apple.com/MANUALS/1000/MA1595/en_US/ipad_user_guide.pdf"] ];
    self.task = [self.session downloadTaskWithURL:[NSURL URLWithString:_model.downloadURL]];
    
    [_task resume];
}

/**
 *  恢复下载
 */

- (void)resume
{
    // 传入上次暂停下载返回的数据，就可以恢复下载
    self.task = [self.session downloadTaskWithResumeData:self.resumeData];
    
    [self.task resume]; // 开始任务
    [_downloadBtn setTitle:@"下载中..." forState:UIControlStateNormal];
    self.resumeData = nil;
}

/**
 *  暂停
 */
- (void)pause
{
    __weak typeof(self) selfVc = self;
    [self.task cancelByProducingResumeData:^(NSData *resumeData) {
        //  resumeData : 包含了继续下载的开始位置\下载的url
        selfVc.resumeData = resumeData;
        selfVc.task = nil;
        [_downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
    }];
}


//下载过程中会调用下面的代理方法，指示此次下载的字节数，一共下载的字节数与总字节数。
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    self.progressBar.progress = (double)totalBytesWritten/totalBytesExpectedToWrite;
    NSLog(@"写入量:%lld 下载进度:%f",bytesWritten,(double)totalBytesWritten/totalBytesExpectedToWrite);
}

//下载结束后回调用下面的代理方法，从中同样要移动文件，只是如果要想拿到响应体response的suggestedFilename，需要通过downloadTask。
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 可以使用建议的文件名，与服务端一致
   // NSString *file = [path stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    // 移动文件
    
    
    NSFileManager *mgr = [NSFileManager defaultManager];
    // AtPath : 剪切前的文件路径
    // ToPath : 剪切后的文件路径
    
    
    NSString *resourcePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"/files"];
    
    NSError*  error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:resourcePath])
        [[NSFileManager defaultManager] createDirectoryAtPath:resourcePath withIntermediateDirectories:NO attributes:nil error:&error];
    NSString *DestPath=[resourcePath stringByAppendingString:[@"/" stringByAppendingString:downloadTask.response.suggestedFilename]];
    
    
//    NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
//    
//    NSString * documentsPath = [resourcePath stringByAppendingPathComponent:@"files"];
//    
//    NSString *file = [documentsPath stringByAppendingPathComponent:downloadTask.response.suggestedFilename];

    NSLog(@"path is  %@\n", DestPath);
    _model.filePath = DestPath;
    [mgr moveItemAtPath:location.path toPath:DestPath error:nil];
    [_downloadBtn setTitle:@"开始阅读" forState:UIControlStateNormal];
    [self.progressBar setHidden:YES];
    //存储追加下载完成后的bookID
    NSString* bookIDDones = [LSYReadUtilites getBookIDDone];
    if(![bookIDDones containsString:self.model.bookName]){//如果没有这个bookID
        bookIDDones = [bookIDDones stringByAppendingString:self.model.bookName];
        [[NSUserDefaults standardUserDefaults] setObject:[bookIDDones stringByAppendingString:@","]forKey:@"BookIDDone"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewBookDownloaded" object:@"success"];
    }
    
    //    // 提示下载完成
    //    [[[UIAlertView alloc] initWithTitle:@"下载完成" message:downloadTask.response.suggestedFilename delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil] show];
    
    
    
    
    
}




#pragma mark 任务完成，不管是否下载成功
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error{
    NSLog(@"暂停下载！Session download task  is failed. Error is %@\n",
          error);
    //    NSLog(@"暂停下载！Session %@ download task %@ is failed. Error is %@\n",
    //          session, task, error);
    
    //  _progressBar.progress = 0;
}


//要恢复下载数据很容易，只需要通过断点创建任务即可。断点续传开始时会调用下面的代理方法说明文件信息
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSLog(@"恢复下载！Session download task resumed at offset %lld bytes out of an expected %lld bytes.\n",
          fileOffset, expectedTotalBytes);
    
    //    NSLog(@"Session %@ download task %@ resumed at offset %lld bytes out of an expected %lld bytes.\n",
    //          session, downloadTask, fileOffset, expectedTotalBytes);
    
    //    // 传入上次暂停下载返回的数据
    //    NSURLSessionDownloadTask *task = [session downloadTaskWithResumeData:self.resumeData];
    //    [task resume];
    //    _task = task;
    //    _resumeData = nil;
}


@end
