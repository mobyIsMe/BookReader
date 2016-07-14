//
//  BookStoreTabBar.m
//  LSYReader
//
//  Created by hongli on 16/7/8.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "BookStoreTabBar.h"

@interface BookStoreTabBar ()

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
