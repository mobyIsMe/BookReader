//
//  BookStoreTabBar.m
//  LSYReader
//
//  Created by hongli on 16/7/8.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "BookStoreTabBar.h"
#import "BookStoreTableViewCell.h"
#import "JSONParser.h"
#import "BookModel.h"
#import "MJRefresh.h"
#import "LSYReadPageViewController.h"
static  NSString* bookIDDoneStr;
static  NSString* bookIDContinueStr;
#define REFRESH_URL @"http://stdl.qq.com/stdl/ipad/liteapp/novel1/list/"


@interface BookStoreTabBar (){
    int pageCount;
}
@end

@implementation BookStoreTabBar



- (id) initBookStore{
    if(self = [super init]){
        self.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"书城" image:nil tag:2];
    }
    return self;
}

-(NSMutableArray*)dataArr{
    if(!_dataArr){
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-113);
    pageCount = 1;
    //_dataArr = [[NSMutableArray alloc]init];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // Hide the time
    //self.tableView.header.lastUpdatedTimeKey.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
  
}

-(void)loadNewData{
    //联网下载书城数据
    //dispatch_async(dispatch_get_global_queue(0, 0), ^{
    NSString* pageStr = [NSString stringWithFormat:@"%d.json", pageCount];
    NSString* dataURL = [REFRESH_URL stringByAppendingString: pageStr];
    [JSONParser fetchBookModelWithURL:dataURL completeBlock:^(NSArray *dataarray,NSError *error){
        if(!error){
            [self.dataArr removeAllObjects];//书籍列表清空 加载第一页
            [self.dataArr addObjectsFromArray:dataarray];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
        
    }];
    //});
}

-(void)loadMoreData{
    //联网下载书城数据
    //dispatch_async(dispatch_get_global_queue(0, 0), ^{
    NSString* pageStr = [NSString stringWithFormat:@"%d.json", ++pageCount];
    NSString* dataURL = [REFRESH_URL stringByAppendingString:pageStr];
    [JSONParser fetchBookModelWithURL:dataURL completeBlock:^(NSArray *dataarray,NSError *error){
        if(!error){
            [self.dataArr addObjectsFromArray:dataarray];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }else if([error.localizedDescription isEqualToString:@"No data returned"]){
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }];
    //});
}

//用来指定表视图的分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //分区设置为1
    return 1;
}

//用来指定特定分区有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //设置为20行
    return _dataArr.count;
}

//配置特定行中的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
   
    BookStoreTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        //单元格样式设置为UITableViewCellStyleDefault
        cell = [[BookStoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    BookModel* item=_dataArr[indexPath.row];
    cell.bookTitle.text = item.bookName;
    if(![item.bookName containsString:@"《"]){
        cell.bookTitle.text = [[@"《" stringByAppendingString:item.bookName]stringByAppendingString:@"》"];
        
    }
    cell.authorName.text = item.authorName;
    [cell cellBindingwithBookModel:item];
    [cell.progressBar setHidden:YES];
    cell.delegate = self;
    NSString *btnTitle;
    if([item.downloadState isEqualToString:@"start"]){
        btnTitle = [NSString stringWithFormat:@"下载：%f MB",item.bookSize.floatValue/1024];

    }else if([item.downloadState isEqualToString:@"continue"]){
        btnTitle = @"继续下载";

    }else{
        btnTitle = @"开始阅读";

    }
    [cell.downloadBtn setTitle:btnTitle forState: UIControlStateNormal];
   
    return cell;
}

//设置单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    //这里设置成150
    return 50;
}

//实现cell里点击开始阅读的代理方法
-(void)StartReadingWithBookModel:(BookModel*)model{
  
    LSYReadPageViewController *pageView = [[LSYReadPageViewController alloc] init];
    //pageView.resourceURL = [NSURL URLWithString:model.filePath];    //文件位置
    pageView.resourceURL = [NSURL URLWithString:[model.filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];    //文件位置
    pageView.fileName = model.bookName;
    if(model.bookType==BookTypePDF){
        pageView.isPDF = YES;
    }else{
        pageView.isPDF = NO;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        pageView.model = [LSYReadModel getLocalModelWithURL:pageView.resourceURL];//这个model存储了归档的阅读参数：进度（chapter、page），笔记，背景主题，字体大小
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:pageView animated:YES completion:nil];
        });
    });
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
