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

NS_ENUM(NSInteger,CellState){
    
    //右上角编辑按钮的两种状态；
    //正常的状态，按钮显示“编辑”;
    NormalState,
    //正在删除时候的状态，按钮显示“完成”；
    DeleteState
    
};  

@interface MainViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,assign) enum CellState;

@end

@implementation MainViewController

-(id) init{
    if(self = [super init]){
        self.dataArray = [[NSMutableArray alloc] init];
//        NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
//        
//        NSString * documentsPath = [resourcePath stringByAppendingPathComponent:@"files"];
        NSString *documentsPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"/files"];
        NSError * error;
        NSArray * fileNameLists = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:&error];//获取书名列表
        // 生成数据
        for (int i=0; i<fileNameLists.count; i++) {
            NSString *fileItem = [fileNameLists objectAtIndex:i];
            BookModel *bookModel = [[BookModel alloc] init];
            //bookModel.cover = @"cover.png";
            bookModel.bookName = [fileItem stringByDeletingPathExtension];
//            bookModel.filePath = [[NSBundle mainBundle] pathForResource:bookModel.bookName
//                                                                 ofType:[fileItem pathExtension]];
            
            if ([[fileItem pathExtension]isEqualToString:@"pdf"]) {
                bookModel.filePath = [documentsPath stringByAppendingString:[NSString stringWithFormat:@"/%@.pdf",bookModel.bookName ]];
                bookModel.bookType = BookTypePDF;
                [self.dataArray addObject:bookModel];
            }else if([[fileItem pathExtension]isEqualToString:@"epub"]){
                bookModel.filePath = [documentsPath stringByAppendingString:[NSString stringWithFormat:@"/%@.epub",bookModel.bookName ]];
                bookModel.bookType = BookTypeEPUB;
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                bookModel.cover =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"cover_%@.png",bookModel.bookName]];
                [self.dataArray addObject:bookModel];
            }else if([[fileItem pathExtension]isEqualToString:@"txt"]) {
                bookModel.filePath = [documentsPath stringByAppendingString:[NSString stringWithFormat:@"/%@.txt",bookModel.bookName ]];
                bookModel.bookType = BookTypeTXT;
                [self.dataArray addObject:bookModel];
            }
            
            
        }
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"书架";
    //self.navigationItem.title = @"书架";
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(editBookShelf:)];
    self.navigationItem.rightBarButtonItem = editButton;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newBookDownloaded:) name: @"NewBookDownloaded" object:nil];
    // collectionView 布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 50;//行距
    flowLayout.minimumInteritemSpacing = 1;
    //一开始是正常状态；
    CellState = NormalState;
    // collectionView 初始化
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.frame = CGRectMake(0, 0, DF_WIDTH, DF_HEIGHT);
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[ReadCollectionCell class] forCellWithReuseIdentifier:kCollectionCellIdentifier];
    [self.view addSubview:self.collectionView];
    [self.collectionView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCover:) name:@"LSYCoverNotification" object:nil];

}

-(void)newBookDownloaded:(NSNotification *)no{
    NSString* result = no.object;
    if([result isEqualToString:@"success"]){
        [self init];
        [self.collectionView reloadData];
    }
}


-(void)refreshCover:(NSNotification *)no{
   NSString* resultStr = no.object;
    if([resultStr isEqualToString:@"Success"]){
        [self.collectionView reloadData];
    }
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
    [cell.deleteBtn addTarget:self action:@selector(deleteCellButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    
    return cell;
}

#pragma mark- 点击每个cell的删除按钮
- (void)deleteCellButtonPressed: (id)sender{
    ReadCollectionCell *cell = (ReadCollectionCell *)[sender superview];//获取cell
    
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:cell];//获取cell对应的indexpath;
    NSString* bookIDDones = [LSYReadUtilites getBookIDDone];
    NSString* bookIDToDelete =[[self.dataArray objectAtIndex:indexpath.row] bookName];
    if([bookIDDones containsString:bookIDToDelete]){
        [bookIDDones stringByReplacingOccurrencesOfString:bookIDToDelete withString:@""];
        [[NSUserDefaults standardUserDefaults] setObject:bookIDDones forKey:@"BookIDDone"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
   [LSYReadUtilites deleteFileWithFilePath:[[self.dataArray objectAtIndex:indexpath.row] filePath]];
    [self.dataArray removeObjectAtIndex:indexpath.row];
        [self.collectionView reloadData];
    
}  



//点击每本书事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BookModel *bookModel = [self.dataArray objectAtIndex:indexPath.row];
    if(bookModel.isSelected==NO){
        [self beginReading:bookModel];
//        switch (bookModel.bookType) {
//            case BookTypePDF:
//                [self beginPDF:bookModel];
//                break;
//            case BookTypeTXT:
//                [self beginTXT:bookModel];
//                break;
//            case BookTypeEPUB:
//                [self beginEpub:bookModel];
//                break;
//            default:
//                break;
//        }
    }
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (IBAction)editBookShelf:(id)sender {
   if(CellState==NormalState){//    //从正常状态变为可删除状态；
       CellState = DeleteState;
       self.navigationItem.rightBarButtonItem.title = @"完成";
       for(BookModel* item in self.dataArray){
                item.isSelected = YES;
               }
       
   }else{
       CellState = NormalState;
       self.navigationItem.rightBarButtonItem.title = @"编辑";
       for(BookModel* item in self.dataArray){
           
           item.isSelected = NO;
        }
      
   }
    
    [self.collectionView reloadData];
    
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


-(void) beginReading:(BookModel*)bookModel {
    LSYReadPageViewController *pageView = [[LSYReadPageViewController alloc] init];
    //pageView.resourceURL = [NSURL URLWithString:bookModel.filePath];    //文件位置
    pageView.resourceURL = [NSURL URLWithString:[bookModel.filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];    //文件位置
    if(bookModel.bookType!=BookTypePDF){
        pageView.isPDF = NO;
    }else{
        pageView.isPDF = YES;
        pageView.fileName = bookModel.bookName;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        pageView.model = [LSYReadModel getLocalModelWithURL: pageView.resourceURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self presentViewController:pageView animated:YES completion:nil];
        });
    });

}
//- (void) beginTXT:(BookModel*)bookModel {
//    LSYReadPageViewController *pageView = [[LSYReadPageViewController alloc] init];
//   // NSURL *fileURL = [[NSBundle mainBundle] URLForResource:bookModel.bookName withExtension:@"txt"];
//    
//    pageView.resourceURL = [NSURL URLWithString:bookModel.filePath];    //文件位置
//    pageView.isPDF = NO;
//
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        
//        pageView.model = [LSYReadModel getLocalModelWithURL: pageView.resourceURL];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [self presentViewController:pageView animated:YES completion:nil];
//        });
//    });
//    
//}

//-(void)beginEpub:(BookModel*)bookModel{
//    LSYReadPageViewController *pageView = [[LSYReadPageViewController alloc] init];
//   // NSURL *fileURL = [[NSBundle mainBundle] URLForResource:bookModel.bookName withExtension:@"epub"];
//    pageView.resourceURL = [NSURL URLWithString:[bookModel.filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];    //文件位置
//    pageView.isPDF = NO;
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        
//        pageView.model = [LSYReadModel getLocalModelWithURL:pageView.resourceURL];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self presentViewController:pageView animated:YES completion:nil];
//        });
//    });
//}


//-(void)beginPDF:(BookModel*)bookModel{
//    //开始跳转PDF阅读页
//    LSYReadPageViewController *pageView = [[LSYReadPageViewController alloc] init];
//    //NSURL *fileURL = [[NSBundle mainBundle] URLForResource:bookModel.bookName withExtension:@"pdf"];
////    NSURL* fileURL = [NSURL URLWithString:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:[@"/files"stringByAppendingString:[NSString stringWithFormat:@"%@.pdf",bookModel.bookName ]]]];
//    pageView.resourceURL = [NSURL URLWithString:bookModel.filePath];    //文件位置
//    pageView.fileName = bookModel.bookName;
//    //pageView.subDirName=@"files";
//    pageView.isPDF = YES;
//    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        
//        pageView.model = [LSYReadModel getLocalModelWithURL:pageView.resourceURL];//这个model存储了归档的阅读参数：进度（chapter、page），笔记，背景主题，字体大小
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self presentViewController:pageView animated:YES completion:nil];
//        });
//    });
//    
//}

@end
