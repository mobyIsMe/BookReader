//
//  BookStoreTabBar.h
//  LSYReader
//
//  Created by hongli on 16/7/8.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookStoreTableViewCell.h"
@interface BookStoreTabBar : UITableViewController<StartReadAfterDownloadDelegate>
@property(nonatomic,strong)NSMutableArray* dataArr;
@property(nonatomic,strong)NSString* dataURL;

- (id) initBookStore;
@end
