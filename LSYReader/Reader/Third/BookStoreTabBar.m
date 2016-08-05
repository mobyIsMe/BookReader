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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel* bookTab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-40, 40, 80,80)];
    //bookTab.text = @"我是书城";
    [self.view addSubview:bookTab];
    pageCount = 1;
    _dataArr = [[NSMutableArray alloc]init];
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
            [_dataArr removeAllObjects];//书籍列表清空 加载第一页
            [_dataArr addObjectsFromArray:dataarray];
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
            [_dataArr addObjectsFromArray:dataarray];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
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
    if(![cell.bookTitle.text hasPrefix:@"《"]){
        cell.bookTitle.text = [[@"《" stringByAppendingString:item.bookName]stringByAppendingString:@"》"];

    }else {
        cell.bookTitle.text = item.bookName;

    }
    cell.authorName.text = item.authorName;
    //[cell.downloadBtn ] = _dataArr[indexPath.row].bookSize;
    NSString *btnTitle = [NSString stringWithFormat:@"下载：%f MB",item.bookSize.floatValue/1024];
    [cell.downloadBtn setTitle:btnTitle forState: UIControlStateNormal];
    
    return cell;
}

//设置单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    //这里设置成150
    return 50;
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
