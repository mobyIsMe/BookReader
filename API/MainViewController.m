//
//  MainViewController.m
//  UICollectionVIewDemo
//
//  Created by HD on 16/7/12.
//  Copyright © 2016年 hongli. All rights reserved.
//

#import "MainViewController.h"
#import "ReadCollectionCell.h"
#import "BookModel.h"
#import <QuartzCore/QuartzCore.h>
#import "LSYReadViewController.h"
#import "LSYReadPageViewController.h"
#import "LSYReadUtilites.h"
#import "LSYReadModel.h"
#import "ZPDFReaderController.h"
#define DF_WIDTH self.view.frame.size.width
#define DF_HEIGHT self.view.frame.size.height

static NSInteger padding = 10;
static NSInteger count = 3; // 每行三个
static NSString *kCollectionCellIdentifier = @"CollectionCellIdentifier";

@interface MainViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation MainViewController

-(id) init{
    if(self = [super init]){
        self.dataArray = [[NSMutableArray alloc] init];
        NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
        
        NSString * documentsPath = [resourcePath stringByAppendingPathComponent:@"files"];
        
        NSError * error;
        NSArray * fileNameLists = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:&error];//获取书名列表
        // 生成数据
        for (int i=0; i<fileNameLists.count; i++) {
            NSString *fileItem = [fileNameLists objectAtIndex:i];
            BookModel *bookModel = [[BookModel alloc] init];
            //bookModel.cover = @"cover.png";
            bookModel.bookName = [fileItem stringByDeletingPathExtension];
            bookModel.filePath = [[NSBundle mainBundle] pathForResource:bookModel.bookName
                                                                 ofType:[fileItem pathExtension]];
            
            if ([[fileItem pathExtension]isEqualToString:@"pdf"]) {
                bookModel.bookType = BookTypePDF;
            }else if([[fileItem pathExtension]isEqualToString:@"epub"]){
                bookModel.bookType = BookTypeEPUB;
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                bookModel.cover =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"cover_%@.png",bookModel.bookName]];
            }else {
                bookModel.bookType = BookTypeTXT;
            }
            
            [self.dataArray addObject:bookModel];
        }
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"书架";
    // collectionView 布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 50;//行距
    flowLayout.minimumInteritemSpacing = 1;

    // collectionView 初始化
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.frame = CGRectMake(0, 0, DF_WIDTH, DF_HEIGHT);
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[ReadCollectionCell class] forCellWithReuseIdentifier:kCollectionCellIdentifier];
    [self.view addSubview:self.collectionView];
    [self.collectionView reloadData];

}



#pragma mark UICollectionView data source.

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ReadCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellIdentifier forIndexPath:indexPath];
    BookModel *bookModel =  self.dataArray[indexPath.row];
    [cell configBookCellModel:bookModel];//设置bookmodel的封面
    return cell;
}


//点击每本书事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BookModel *bookModel = [self.dataArray objectAtIndex:indexPath.row];
    switch (bookModel.bookType) {
        case BookTypePDF:
            [self beginPDF:bookModel];
            break;
        case BookTypeTXT:
            [self beginTXT:bookModel];
            break;
        case BookTypeEPUB:
            [self beginEpub:bookModel];
            break;
        default:
            break;
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellW = (DF_WIDTH-20*(count+2))/count; // 计算一个cell 的宽度 (屏幕宽度 - 间距之间空白)/每行个数
    CGFloat cellH = cellW*4/3 +20; // 随便设置的一个高度 封面比例4:3 20 表示标题高度
    
    return CGSizeMake(cellW, cellH);
}

////定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(padding, 25, padding, 25); // 整个CollectionView 到边界的间距 顺序 上、左、下、右
}

//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return padding;
}

- (void) beginTXT:(BookModel*)bookModel {
    LSYReadPageViewController *pageView = [[LSYReadPageViewController alloc] init];
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:bookModel.bookName withExtension:@"txt"];
    
    pageView.resourceURL = fileURL;    //文件位置
    pageView.isPDF = NO;

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        pageView.model = [LSYReadModel getLocalModelWithURL: pageView.resourceURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self presentViewController:pageView animated:YES completion:nil];
        });
    });
    
}

-(void)beginEpub:(BookModel*)bookModel{
    LSYReadPageViewController *pageView = [[LSYReadPageViewController alloc] init];
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:bookModel.bookName withExtension:@"epub"];
    pageView.resourceURL = fileURL;    //文件位置
    pageView.isPDF = NO;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        pageView.model = [LSYReadModel getLocalModelWithURL:pageView.resourceURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:pageView animated:YES completion:nil];
        });
    });
}


-(void)beginPDF:(BookModel*)bookModel{
    //开始跳转PDF阅读页
//    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:bookModel.bookName withExtension:@"pdf"];
//    ZPDFReaderController *targetViewCtrl = [[ZPDFReaderController alloc] init];
//    targetViewCtrl.fileName = [fileURL lastPathComponent];
//    targetViewCtrl.subDirName=@"files";
//    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        
//        //pageView.model = [LSYReadModel getLocalModelWithURL:fileURL];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            //暂时添加导航栏
//            UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:targetViewCtrl];
//            [self presentViewController:nav animated:YES completion:nil];
//            
//        });
//    });
    
    LSYReadPageViewController *pageView = [[LSYReadPageViewController alloc] init];
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:bookModel.bookName withExtension:@"pdf"];
    pageView.resourceURL = fileURL;    //文件位置
    pageView.fileName = [fileURL lastPathComponent];
    pageView.subDirName=@"files";
    pageView.isPDF = YES;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        pageView.model = [LSYReadModel getLocalModelWithURL:pageView.resourceURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:pageView animated:YES completion:nil];
        });
    });
    
}

@end
