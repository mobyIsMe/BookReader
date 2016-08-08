//
//  AboutTabBar.m
//  LSYReader
//
//  Created by hongli on 16/7/8.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "AboutTabBar.h"

@interface AboutTabBar ()

@end

@implementation AboutTabBar

- (id) initAbout{
    if(self = [super init]){
//        self.title = @"关于";
//        self.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"关于" image:nil tag:3];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel* aboutTab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-40, 40, 80,80)];
    aboutTab.text = @"我是关于";
    [self.view addSubview:aboutTab];
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
