//
//  JSONParser.m
//  LSYReader
//
//  Created by hongli on 16/7/29.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "JSONParser.h"
#import"BookModel.h"
#define GET_URL @"http://stdl.qq.com/stdl/ipad/liteapp/novel1/list/1.json"

@implementation JSONParser
//+ (void)fetchBookModelcompleteBlock:(void(^)(NSArray* dataArray,NSError* error))block{
//    __block NSMutableArray* bookModelArr;
//    NSURL *url = [[NSURL alloc] initWithString:GET_URL];
//     NSError *error;
//    NSURLRequest *requst = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];[NSURLConnection sendAsynchronousRequest:requst queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,  NSData *data, NSError *connectionError) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:error];
//        NSNumber  *num = [dic valueForKey:@"datanum" ];
//        long totalDataNum = [num floatValue];
//         bookModelArr = [[NSMutableArray alloc]initWithCapacity:totalDataNum];
//        NSMutableArray* dictArr =[dic valueForKey:@"data"];
//      for(NSDictionary *dict in dictArr){
//          BookModel* item = [[BookModel alloc]initWithDict:dict];
//          [bookModelArr addObject:item];
//        }
//        
//        if(bookModelArr.count){
//            block([NSArray arrayWithArray:bookModelArr],nil);
//        }else{
//            block([NSArray array],error);
//
//        }
//}];

//}
    
+ (void)fetchBookModelCompleteBlock:(void(^)(NSArray *dataarray,NSError *error))block
{
    __block NSMutableArray* bookModelArr = [[NSMutableArray alloc] init]; // 可变数组使用前必须进行初始化
    __block NSError *error;
    NSURL *url = [[NSURL alloc] initWithString:GET_URL];
    NSURLRequest *requst = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    [NSURLConnection sendAsynchronousRequest:requst queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,  NSData *data, NSError *connectionError) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSNumber  *num = [dic valueForKey:@"datanum" ];
        long totalDataNum = [num floatValue];
        bookModelArr = [[NSMutableArray alloc]initWithCapacity:totalDataNum];
        NSMutableArray* dictArr =[dic valueForKey:@"data"];
        for(NSDictionary *dict in dictArr){
            BookModel* item = [[BookModel alloc]initWithDict:dict];
            [bookModelArr addObject:item];
        }
        
        if (bookModelArr.count) {
            block([NSArray arrayWithArray:bookModelArr],nil);
        }else{
            block([NSArray array],error);
        }
    }];
}

    
    
    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
//    
//    [request setHTTPMethod:@"GET"];
//    
//    NSURLResponse *response = nil;
//    
//    NSError *error = nil;
//    
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    // 解析数据
//    NSArray *array = [NSJSONSerialization     JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//    
//    // 私有属性存放解析后的数据
//    array = [[NSMutableArray alloc] initWithCapacity:[array valueForKey:@"datanum"]];
//    
    // 这里我们需要一个模型
//    for (NSDictionary *dict in [array valueForKey:@"data"]) {
//        BookModel *item = [BookModel alloc];
//        [item setValuesForKeysWithDictionary:dict];
//        [bookModelArr addObject:item];
//    }
//    // 最后校验一下数据
//    for (BookModel *item in array) {
//        NSLog(@"%@\n\n",item);
//    }
  

@end
